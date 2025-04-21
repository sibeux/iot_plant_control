import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/services/refill_service.dart';

class RefillTandonController extends GetxController{
  final FlutterBackgroundService _service = FlutterBackgroundService();

  void stopService(){
    showTandonPenuhNotification();
    _service.invoke('stopService');
  }
}