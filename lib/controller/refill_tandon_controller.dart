import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/widgets/refill_tandon_widget/refill_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefillTandonController extends GetxController {
  var isServiceRunning = false.obs;
  var isTap = false.obs;
  var isLoading = false.obs;
  final FlutterBackgroundService _service = FlutterBackgroundService();

  @override
  void onInit() {
    super.onInit();
    _checkServiceStatus();
  }

  Future<void> toggleService(bool start, {isFromButton = false}) async {
    isTap.value = !isTap.value;
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    if (start) {
      await prefs.setBool('isFull', false);
      await _service.startService();
    } else {
      await prefs.setBool('isFull', true);
      if (!isFromButton) {
      showTandonPenuhNotification();
      }
      _service.invoke('stopService');
    }

    // Delay to ensure the service status is updated.
    await Future.delayed(const Duration(milliseconds: 500));
    _checkServiceStatus();
  }

  Future<void> _checkServiceStatus() async {
    final isRunning = await _service.isRunning();
    isServiceRunning.value = isRunning;
    isLoading.value = false;
  }
}
