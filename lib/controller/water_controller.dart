import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/models/water_time.dart';

class WaterController extends GetxController {
  var waterTime = RxList<WaterTime>([]);

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  var selectedHour = 0.obs;
  var selectedMinute = 0.obs;

  var countdownString = ''.obs;

  @override
  void onInit() {
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    super.onInit();
  }

  @override
  void onClose() {
    hourController.dispose();
    minuteController.dispose();
    super.onClose();
  }

  void sortWaterTime() {
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

  void addWatering() {
    String time =
        '${selectedHour.value.toString().padLeft(2, '0')}:${selectedMinute.value.toString().padLeft(2, '0')}';
    waterTime.add(WaterTime(time: time, isActive: true));
    sortWaterTime();
  }

  void removeWatering(String id) {
    int index = waterTime.indexWhere((element) => element.id == id);
    waterTime.removeAt(index);
  }

  void toggleWatering(String id, bool value) {
    int index = waterTime.indexWhere((element) => element.id == id);
    if (index != -1) {
      waterTime[index].isActive.value = value;
    }
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
