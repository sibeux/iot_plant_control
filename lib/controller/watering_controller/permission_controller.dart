import 'dart:io';

import 'package:get/get.dart';
import 'package:iot_plant_control/components/colorize_terminal.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  var isExactAlarmGranted = false.obs;
  var isNotificationGranted = false.obs;

  Future<void> requestNotificationPermissionIfNeeded() async {
    if (Platform.isAndroid) {
        final status = await Permission.notification.status;

        if (status.isDenied || status.isRestricted) {
          final result = await Permission.notification.request();
          if (result.isGranted) {
            logSuccess("✔️ Izin notifikasi diberikan.");
            isNotificationGranted.value = true;
          } else {
            logError("❌ Izin notifikasi ditolak.");
            isNotificationGranted.value = false;
          }
        } else if (status.isGranted) {
          logSuccess("✔️ Izin notifikasi sudah diberikan.");
          isNotificationGranted.value = true;
        } else {
          logError("⚠️ Status izin notifikasi: $status");
          isNotificationGranted.value = false;
        }
      
    }
  }


  Future<void> requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.scheduleExactAlarm.request();
      if (result.isGranted) {
        logSuccess("✅ Izin SCHEDULE_EXACT_ALARM diberikan.");
        isExactAlarmGranted.value = true;
      } else {
        logError("❌ Izin SCHEDULE_EXACT_ALARM ditolak.");
        isExactAlarmGranted.value = false;
      }
    } else if (status.isGranted) {
      logSuccess("✔️ Izin SCHEDULE_EXACT_ALARM sudah diberikan sebelumnya.");
      isExactAlarmGranted.value = true;
    } else {
      logError("⚠️ Status izin SCHEDULE_EXACT_ALARM: $status");
      isExactAlarmGranted.value = false;
    }
  }
}
