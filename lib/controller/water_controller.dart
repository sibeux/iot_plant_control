import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterController extends GetxController {
  var waterTime = RxList<WaterTime>([]);

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  var selectedHour = 0.obs;
  var selectedMinute = 0.obs;

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
    await saveWaterTimes(waterTime);
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

  void addWatering() {
    String time =
        '${selectedHour.value.toString().padLeft(2, '0')}:${selectedMinute.value.toString().padLeft(2, '0')}';
    waterTime.add(WaterTime(time: time, isActive: true));
    sortWaterTime();
  }

  Future<void> removeWatering(String id) async {
    int index = waterTime.indexWhere((element) => element.id == id);
    waterTime.removeAt(index);
    await saveWaterTimes(waterTime);
  }

  Future<void> toggleWatering(String id, bool value) async {
    int index = waterTime.indexWhere((element) => element.id == id);
    if (index != -1) {
      waterTime[index].isActive.value = value;
    }
    await saveWaterTimes(waterTime);
  }

  void updateWatering(String id, String time) {
    int index = waterTime.indexWhere((element) => element.id == id);
    if (index != -1) {
      waterTime[index].time = time;
    }
    sortWaterTime();
    updateRefresh.value = !updateRefresh.value;
  }

  Future<void> saveWaterTimes(RxList<WaterTime> list) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        list.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('water_times', jsonList);
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
    } else {
      return 'Watering now';
    }
  }
}
