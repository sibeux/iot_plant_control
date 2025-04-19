import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/models/water_time.dart';

class WaterController extends GetxController {
  var waterTime = RxList<WaterTime>([]);

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  var selectedHour = 0.obs;
  var selectedMinute = 0.obs;

  @override
  void onInit() {
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
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

  void setCurrentTime() {
    final now = DateTime.now();
    hourController = FixedExtentScrollController(initialItem: now.hour);
    minuteController = FixedExtentScrollController(initialItem: now.minute);
  }

  void addWatering(String time) {
    waterTime.add(WaterTime(time: time));
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
}
