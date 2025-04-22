import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

// Untuk watering alarm.
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// Harus di luar class/widget.
@pragma('vm:entry-point')
void startWatering() async {
  debugPrint('Alarm triggered at ${DateTime.now()}');
  // showTandonPenuhNotification();
}

class WaterAlarmController extends GetxController {
  void setAlarm({required String id, required DateTime alarmTime}) async {
    print('setAlarm: $id');

    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      int.tryParse(id)!, // alarm ID
      startWatering,
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  void cancelAlarm({required String id}) async {
    await AndroidAlarmManager.cancel(int.tryParse(id)!);
  }
}
