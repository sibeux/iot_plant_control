import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iot_plant_control/controller/water_alarm_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:iot_plant_control/components/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterController extends GetxController {
  final waterAlarmController = Get.put(WaterAlarmController());
  var waterTime = RxList<WaterTime>([]);

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late TextEditingController durationController;

  var selectedHour = 0.obs;
  var selectedMinute = 0.obs;
  var selectedDuration = '2'.obs;

  var countdownString = ''.obs;

  var updateRefresh = false.obs;

  @override
  Future<void> onInit() async {
    waterTime.value = await loadWaterTimes();
    super.onInit();
  }

  @override
  void onClose() {
    hourController.dispose();
    minuteController.dispose();
    super.onClose();
  }

  Future<void> sortWaterTime() async {
    waterTime.sort((a, b) {
      final timeA = a.time.split(':').map(int.parse).toList();
      final timeB = b.time.split(':').map(int.parse).toList();
      return (timeA[0] * 60 + timeA[1]).compareTo(timeB[0] * 60 + timeB[1]);
    });
  }

  void setCurrentTime() {
    final now = DateTime.now();
    hourController = FixedExtentScrollController(initialItem: now.hour);
    minuteController = FixedExtentScrollController(initialItem: now.minute);
    selectedHour.value = now.hour;
    selectedMinute.value = now.minute;
    setWaterTimeDifference(selectedHour.value, selectedMinute.value);
  }

  void modalChangeSetTime({required int hour, required int minute}) {
    hourController = FixedExtentScrollController(initialItem: hour);
    minuteController = FixedExtentScrollController(initialItem: minute);
    selectedHour.value = hour;
    selectedMinute.value = minute;
    setWaterTimeDifference(selectedHour.value, selectedMinute.value);
  }

  Future<void> addWatering() async {
    final prefs = await SharedPreferences.getInstance();
    final String id =
        (int.parse(prefs.getString('water_id') ?? '0') + 1).toString();
    String time =
        '${selectedHour.value.toString().padLeft(2, '0')}:${selectedMinute.value.toString().padLeft(2, '0')}';
    waterTime.add(
      WaterTime(
        id: id,
        time: time,
        duration: selectedDuration.value,
        isActive: true,
      ),
    );
    showToast(countdownString.value);
    sortWaterTime();
    await prefs.setString('water_id', id);
    await saveWaterTimes(waterTime);
  }

  Future<void> removeWatering(String id) async {
    int index = waterTime.indexWhere((element) => element.id == id);
    waterTime.removeAt(index);
    await saveWaterTimes(waterTime);
  }

  DateTime convertStringToDateTime(String time) {
    // Ambil tanggal hari ini
    DateTime now = DateTime.now();

    // Pisahkan waktu dari string "HH:mm"
    List<String> timeParts = time.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Gabungkan tanggal hari ini dengan waktu yang diberikan
    DateTime dateTime = DateTime(now.year, now.month, now.day, hours, minutes);

    return dateTime;
  }

  Future<void> toggleWatering(String id, bool value) async {
    int index = waterTime.indexWhere((element) => element.id == id);
    if (index != -1) {
      waterTime[index].isActive.value = value;
    }
    if (value) {
      showToast(
        getWaterTimeDifference(
          int.parse(waterTime[index].time.split(':')[0]),
          int.parse(waterTime[index].time.split(':')[1]),
        ),
      );
      print('Alarm set for ${waterTime[index].time}');
      waterAlarmController.setAlarm(
        id: id,
        alarmTime: convertStringToDateTime(waterTime[index].time),
      );
    }
    await saveWaterTimes(waterTime);
  }

  void updateWatering({
    required String id,
    required String time,
    required String duration,
  }) {
    int index = waterTime.indexWhere((element) => element.id == id);
    if (index != -1) {
      waterTime[index].time = time;
      waterTime[index].duration = duration;
    }
    sortWaterTime();
    updateRefresh.value = !updateRefresh.value;
  }

  void formatDuration(String value) {
    String intFormatter(String input) {
      int number = int.parse(input);

      var formatter = NumberFormat.currency(
        locale: 'id',
        symbol: '',
        decimalDigits: 0,
      );

      String formattedNumber = formatter.format(number);
      return formattedNumber;
    }

    if (value.isNotEmpty) {
      value = value.replaceAll('.', '');
      value = value.replaceAll(',', '');
      value = value.replaceAll(' ', '');
    }
    if (value.isNotEmpty) {
      selectedDuration.value = value;
      durationController.text = intFormatter(value);
    }
    if (value == '0') {
      selectedDuration.value = '1';
      durationController.text = selectedDuration.value;
      return;
    }
    update();
  }

  Future<void> saveWaterTimes(RxList<WaterTime> list) async {
    // final mqttController = Get.find<MqttController>();
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> mapList =
        list.map((item) => item.toJson()).toList();

    final String jsonPayload = jsonEncode(mapList);
    // mqttController.publishToBroker(jsonPayload);

    debugPrint('jsonPayload: $jsonPayload');

    // Untuk local storage tetap simpan sebagai List<String>
    final List<String> jsonListForPrefs =
        list.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('water_times', jsonListForPrefs);
  }

  Future<RxList<WaterTime>> loadWaterTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('water_times');

    if (jsonList != null) {
      final items =
          jsonList.map((e) => WaterTime.fromJson(jsonDecode(e))).toList();
      return RxList<WaterTime>.from(items);
    }

    return RxList<WaterTime>();
  }

  void setWaterTimeDifference(int selectedHour, int selectedMinute) {
    final now = DateTime.now();
    var waterTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedHour,
      selectedMinute,
    );

    // Jika waktu sudah lewat hari ini, set ke besok
    if (waterTime.isBefore(now)) {
      waterTime = waterTime.add(const Duration(days: 1));
    }

    final diff = waterTime.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);

    if (hours == 0 && minutes > 0) {
      countdownString.value =
          'Watering in $minutes ${minutes == 1 ? "minute" : "minutes"}';
    } else if (hours > 0 && minutes == 0) {
      countdownString.value =
          'Watering in $hours ${hours == 1 ? "hour" : "hours"}';
    } else if (hours > 0 && minutes > 0) {
      countdownString.value =
          'Watering in $hours ${hours == 1 ? "hour" : "hours"} '
          '$minutes ${minutes == 1 ? "minute" : "minutes"}';
    } else if (hours == 0 && minutes < 1) {
      countdownString.value = 'Watering in less than 1 minute';
    } else {
      countdownString.value = 'Watering now';
    }
  }

  String getWaterTimeDifference(int selectedHour, int selectedMinute) {
    final now = DateTime.now();
    var waterTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedHour,
      selectedMinute,
    );

    // Jika waktu sudah lewat hari ini, set ke besok
    if (waterTime.isBefore(now)) {
      waterTime = waterTime.add(const Duration(days: 1));
    }

    final diff = waterTime.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);

    if (hours == 0 && minutes > 0) {
      return 'Watering in $minutes ${minutes == 1 ? "minute" : "minutes"}';
    } else if (hours > 0 && minutes == 0) {
      return 'Watering in $hours ${hours == 1 ? "hour" : "hours"}';
    } else if (hours > 0 && minutes > 0) {
      return 'Watering in $hours ${hours == 1 ? "hour" : "hours"} '
          '$minutes ${minutes == 1 ? "minute" : "minutes"}';
    } else if (hours == 0 && minutes < 1) {
      return 'Watering in less than 1 minute';
    } else {
      return 'Watering now';
    }
  }
}
