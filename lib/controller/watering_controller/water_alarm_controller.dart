import 'dart:async';
import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:iot_plant_control/components/string_formatter.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:iot_plant_control/widgets/water_widget/watering_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// Harus di luar class/widget.
@pragma('vm:entry-point')
void startWatering() async {
  final box = GetStorage();
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final MqttController mqttController = Get.put(MqttController());
  int counter = 0;
  final now = DateTime.now();
  debugPrint('Start alarm triggered at $now');
  showWateringNotification(true);
  Timer.periodic(const Duration(milliseconds: 500), (timer) {
    if (counter == 0 && mqttController.mqttIsConnected.value) {
      mqttController.publishToBroker('startwatering');
      counter++;
      timer.cancel();
    }
  });

  final List<String>? jsonList = prefs.getStringList('water_times');
  final String hhmm = DateFormat('HH:mm').format(now);

  print(jsonList);

  if (jsonList != null) {
    final items =
        jsonList.map((e) => WaterTime.fromJson(jsonDecode(e))).toList();
    int index = items.indexWhere((element) {
      return element.time == hhmm &&
          element.isConflict.value == false &&
          element.isActive.value == true;
    });
    print(index);
    final duration = Duration(minutes: int.parse(items[index].duration));

    box.write('current_ring', items[index].id);
    int counter = 0;

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (counter == 0) {
        await AndroidAlarmManager.oneShotAt(
          now.add(duration), // alarm time
          int.tryParse(items[index].id)!, // alarm ID
          stopWatering, // callback function
          alarmClock: true,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
        );
        debugPrint(
          'Alarm off set for id: ${items[index].id} at ${now.add(duration)}',
        );
        counter++;
        timer.cancel();
      }
    });
  }
}

// Harus di luar class/widget.
@pragma('vm:entry-point')
void stopWatering() async {
  final MqttController mqttController = Get.put(MqttController());
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final box = GetStorage();
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
  final List<String>? jsonList = prefs.getStringList('water_times');
  if (jsonList != null) {
    final items =
        jsonList.map((e) => WaterTime.fromJson(jsonDecode(e))).toList();
    final index = items.indexWhere(
      (element) => element.id == box.read('current_ring'),
    );

    DateTime waterDate = convertStringToDateTime(items[index].time);
    if (waterDate.isBefore(DateTime.now())) {
      waterDate = waterDate.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.oneShotAt(
      waterDate, // alarm time
      int.tryParse(items[index].id)!, // alarm ID
      startWatering, // callback function
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    debugPrint(
      'Alarm on again set for id: ${items[index].id} at tomorrow: $waterDate',
    );
  }
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
      // Ini harusnya tidak ada, tapi buat jaga2 & biar cepet.
      await AndroidAlarmManager.cancel(int.tryParse(id)!);
    }
  }
}
