import 'package:get/get.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';

class TdsController extends GetxController {
  var minTdsValue = 0.0.obs;
  var maxTdsValue = 0.0.obs;

  void setMinTdsValue(double value) {
    final mqttController = Get.find<MqttController>();
    minTdsValue.value = value;
    mqttController.publishTDS('Min TDS: ${value.toStringAsFixed(1)}');
  }

  void setMaxTdsValue(double value) {
    final mqttController = Get.find<MqttController>();
    maxTdsValue.value = value;
    mqttController.publishTDS('Max TDS: ${value.toStringAsFixed(1)}');
  }
}
