import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iot_plant_control/components/colorize_terminal.dart';
import 'package:iot_plant_control/components/string_formatter.dart';
import 'package:iot_plant_control/controller/watering_controller/condition_checker.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:iot_plant_control/components/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WaterController extends GetxController {
  var waterTime = RxList<WaterTime>([]);

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late TextEditingController durationController;

  var selectedHour = 0.obs;
  var selectedMinute = 0.obs;
  var selectedDuration = '30'.obs;

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
    waterTime.removeAt(index);
    validateSortedAlarms(waterTime);
    await saveWaterTimes(waterTime);
  }

  Future<void> toggleWatering(String id, bool value) async {
    int index = waterTime.indexWhere((element) => element.id == id);
    DateTime waterDate = convertStringToDateTime(waterTime[index].time);
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

  Future<String> getRailwayUrl() async {
    const url =
        "https://sibeux.my.id/project/myplant-php-jwt/api/railway_url?method=get_railway_url";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200 || response.body.isEmpty) {
        logError('Failed to fetch railway url: HTTP ${response.statusCode}');
        return '';
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] != 'success') {
        logError('API returned non-success status: ${data['status']}');
        return '';
      }

      final railwayUrl = data['data']?['url'];
      if (railwayUrl == null || railwayUrl.isEmpty) {
        logError('No railway url returned in data.');
        return '';
      }

      logSuccess('Railway URL fetched successfully: ${data['data']?['url']}');
      return railwayUrl ?? '';
    } catch (e, stack) {
      logError('Exception during date fetch: $e\n$stack');
      return '';
    }
  }

  Future<void> sendWateringSchedule(List<String> data) async {
    // Dokumentasi pake cron railway
    // https://chatgpt.com/c/68405559-6ac0-8002-bfd2-0c249b5d824d
    // Cek email mana yang dipake untuk cron job
    final railwayUrl = await getRailwayUrl();
    final url = Uri.parse(railwayUrl);

    logInfo('Payload: $data');

    // asumsikan time di data adalah Waktu Indonesia Barat (WIB, UTC+7)
    final schedule =
        data
            .map((item) => jsonDecode(item))
            .where(
              (item) => item['isActive'] == true && item['isConflict'] == false,
            )
            .map((item) {
              // parsing string jam:menit ke DateTime dengan zona WIB (UTC+7)
              final localTime = DateFormat('HH:mm').parse(item['time']);
              final utcTime = localTime.subtract(
                const Duration(hours: 7),
              ); // WIB → UTC

              return {
                'time': DateFormat('HH:mm').format(utcTime),
                'duration': int.parse(item['duration']),
              };
            })
            .toList();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(schedule),
    );

    if (response.statusCode == 200) {
      logSuccess("Schedule sent successfully: ${response.body}");
    } else {
      logError("Failed to send schedule: ${response.body}");
    }
  }

  Future<void> saveWaterTimes(RxList<WaterTime> list) async {
    final prefs = await SharedPreferences.getInstance();

    // final List<Map<String, dynamic>> mapList =
    //     list.map((item) => item.toJson()).toList();
    // final String jsonPayload = jsonEncode(mapList);
    // logInfo('jsonPayload: $jsonPayload');

    // Untuk local storage tetap simpan sebagai List<String>
    final List<String> jsonListForPrefs =
        list.map((item) => jsonEncode(item.toJson())).toList();

    sendWateringSchedule(jsonListForPrefs);

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
