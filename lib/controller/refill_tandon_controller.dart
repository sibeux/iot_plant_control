import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/services/refill_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefillTandonController extends GetxController{
  final FlutterBackgroundService _service = FlutterBackgroundService();

  void stopService() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFull', true);
    showTandonPenuhNotification();
    _service.invoke('stopService');
  }
}