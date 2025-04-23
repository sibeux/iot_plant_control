import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:iot_plant_control/components/string_formatter.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/check_overlapping.dart';
import 'package:iot_plant_control/controller/watering_controller/water_alarm_controller.dart';
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

  var timeNotifier = ''.obs;
  var isWaterOn = false.obs;

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

  Future<void> removeWatering(String id) async {
    int index = waterTime.indexWhere((element) => element.id == id);
    waterAlarmController.cancelAlarm(id: id);
    waterTime.removeAt(index);
    validateSortedAlarms(waterTime);
    await saveWaterTimes(waterTime);
  }

  Future<void> toggleWatering(String id, bool value) async {
    int index = waterTime.indexWhere((element) => element.id == id);
    DateTime waterDate = convertStringToDateTime(waterTime[index].time);
    final box = GetStorage();
    // Jika waktu sudah lewat hari ini, set ke besok
    if (waterDate.isBefore(DateTime.now())) {
      waterDate = waterDate.add(const Duration(days: 1));
    }
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
      waterAlarmController.setAlarm(id: id, alarmTime: waterDate);
    } else {
      print(box.read('current_ring'));
      // if (box.read('current_ring') == id) {
      //   box.remove('current_ring');
      //   final SendPort? isolateSendPort = IsolateNameServer.lookupPortByName(
      //     'water_alarm_receive_port',
      //   );
      //   if (isolateSendPort != null) {
      //     isolateSendPort.send('stop');
      //   } else {
      //     debugPrint('Isolate port tidak ditemukan');
      //   }
      //   Get.find<MqttController>().publishToBroker('stopwatering');
      // }
      waterAlarmController.cancelAlarm(id: id);
    }
    await saveWaterTimes(waterTime);
  }

  void updateWatering({
    required String id,
    required String time,
    required String duration,
    bool isConflict = false,
  }) {
    int index = waterTime.indexWhere((element) => element.id == id);
    if (index != -1) {
      waterTime[index].time = time;
      waterTime[index].duration = duration;
      waterTime[index].isActive.value = !isConflict;
      waterTime[index].isConflict.value = isConflict;
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
