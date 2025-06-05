import 'package:get/get.dart';
import 'package:iot_plant_control/components/colorize_terminal.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  var isExactAlarmGranted = false.obs;

  Future<void> requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.scheduleExactAlarm.request();
      if (result.isGranted) {
        logSuccess("✅ Izin SCHEDULE_EXACT_ALARM diberikan.");
        isExactAlarmGranted.value = true;
      } else {
        logError("❌ Izin ditolak.");
        isExactAlarmGranted.value = false;
      }
    } else if (status.isGranted) {
      logSuccess("✔️ Izin sudah diberikan sebelumnya.");
      isExactAlarmGranted.value = true;
    } else {
      logError("⚠️ Status izin: $status");
      isExactAlarmGranted.value = false;
    }
  }
}
