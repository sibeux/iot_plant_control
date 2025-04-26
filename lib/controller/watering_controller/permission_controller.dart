import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  var isExactAlarmGranted = false.obs;

  Future<void> requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.scheduleExactAlarm.request();
      if (result.isGranted) {
        debugPrint("✅ Izin SCHEDULE_EXACT_ALARM diberikan.");
        isExactAlarmGranted.value = true;
      } else {
        debugPrint("❌ Izin ditolak.");
        isExactAlarmGranted.value = false;
      }
    } else if (status.isGranted) {
      debugPrint("✔️ Izin sudah diberikan sebelumnya.");
      isExactAlarmGranted.value = true;
    } else {
      debugPrint("⚠️ Status izin: $status");
      isExactAlarmGranted.value = false;
    }
  }
}
