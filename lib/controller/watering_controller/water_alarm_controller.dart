import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iot_plant_control/components/string_formatter.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/condition_checker.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:iot_plant_control/widgets/water_widget/watering_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

// The background
SendPort? sendPort;
// Global supaya bisa diakses saat stop
Timer? countdownTimer;

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// Harus di luar class/widget.
@pragma('vm:entry-point')
void startWatering() async {
  final box = GetStorage();
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final MqttController mqttController = Get.put(
    MqttController(),
    tag: 'mqtt-start-watering',
  );
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

  if (jsonList != null) {
    final items =
        jsonList.map((e) => WaterTime.fromJson(jsonDecode(e))).toList();
    int index = items.indexWhere((element) {
      final duration = Duration(seconds: int.parse(element.duration));
      final bool inRange = isNowWithinRangeInclusive(
        alarmTime: convertStringToDateTime(element.time),
        duration: duration,
      );
      return inRange &&
          element.isConflict.value == false &&
          element.isActive.value == true;
    });
    final duration = Duration(seconds: int.parse(items[index].duration));
    
    int counter = 0;

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (counter == 0) {
        box.write('current_ring', items[index].id);
        await AndroidAlarmManager.oneShotAt(
          now.add(duration), // alarm time
          int.tryParse(items[index].id)!, // alarm ID
          stopWatering, // callback function
          alarmClock: true,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
          allowWhileIdle: true,
        );
        debugPrint(
          'Alarm off set for id: ${items[index].id} at ${now.add(duration)}',
        );
        debugPrint(
          'current ring from pragma (startWatering): ${box.read('current_ring')}',
        );
        counter++;
        timer.cancel();
      }
    });

    // int durationSeconds = duration.inSeconds;
    // int remaining = durationSeconds;

    final receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      'water_alarm_receive_port',
    );

    receivePort.listen((message) {
      if (message == 'stop') {
        countdownTimer?.cancel();
        sendPort!.send('done');
        debugPrint('Timer dihentikan oleh UI');
      }
    });

    // This will be null if we're running in the background.
    sendPort ??= IsolateNameServer.lookupPortByName("water_alarm_port");
    sendPort?.send(null);

    // countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   final int minutes = remaining ~/ 60;
    //   final int seconds = remaining % 60;
    //   final formatted =
    //       '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    //   sendPort!.send(formatted);

    //   if (remaining == 0) {
    //     timer.cancel();
    //     sendPort!.send('done');
    //     IsolateNameServer.removePortNameMapping('water_alarm_receive_port');
    //   } else {
    //     remaining--;
    //   }
    //   box.write('current_ring', items[index].id);
    // });
  }
}

// Harus di luar class/widget.
@pragma('vm:entry-point')
void stopWatering() async {
  final MqttController mqttController = Get.put(
    MqttController(),
    tag: 'mqtt-stop-watering',
  );
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
  debugPrint(
    'current ring from pragma (stopWatering): ${box.read('current_ring')}',
  );
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
      allowWhileIdle: true,
    );
    debugPrint(
      'Alarm on again set for id: ${items[index].id} at tomorrow: $waterDate',
    );
    box.remove('current_ring');
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
      allowWhileIdle: true,
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
