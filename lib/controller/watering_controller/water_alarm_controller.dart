import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/widgets/water_widget/watering_notification.dart';

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// Harus di luar class/widget.
@pragma('vm:entry-point')
void startWatering() async {
  final MqttController mqttController = Get.put(MqttController());
  int counter = 0;
  debugPrint('Start alarm triggered at ${DateTime.now()}');
  showWateringNotification(true);
  Timer.periodic(const Duration(milliseconds: 500), (timer) {
    if (counter == 0 && mqttController.mqttIsConnected.value) {
      mqttController.publishToBroker('startwatering');
      counter++;
      timer.cancel();
    }
  });
}

// Harus di luar class/widget.
@pragma('vm:entry-point')
void stopWatering() async {
  final MqttController mqttController = Get.put(MqttController());
  int counter = 0;
  debugPrint('Stop alarm triggered at ${DateTime.now()}');
  showWateringNotification(false);
  Timer.periodic(const Duration(milliseconds: 500), (timer) {
    if (counter == 0 && mqttController.mqttIsConnected.value) {
      mqttController.publishToBroker('stopwatering');
      counter++;
      timer.cancel();
    }
  });
}

class WaterAlarmController extends GetxController {
  void setAlarm({required String id, required DateTime alarmTime}) async {
    debugPrint('Alarm set for id: $id at $alarmTime');
    // Start alarm manager.
    await AndroidAlarmManager.oneShotAt(
      alarmTime, // alarm time
      int.tryParse(id)!, // alarm ID
      startWatering, // callback function
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  void cancelAlarm({required String id}) async {
    int index = Get.find<WaterController>().waterTime.indexWhere(
      (element) => element.id == id,
    );
    if (index != -1 &&
        !Get.find<WaterController>().waterTime[index].isConflict.value) {
      debugPrint('Alarm canceled for id: $id');
      await AndroidAlarmManager.cancel(int.tryParse(id)!);
      return;
    } else {
      debugPrint('Alarm not found for $id. Enjoy your day!');
    }
  }
}
