import 'package:get/get.dart';

class TdsController extends GetxController{
  var minTdsValue = 0.0.obs;
  var maxTdsValue = 0.0.obs;

  void setMinTdsValue(double value) {
    minTdsValue.value = value;
  }
  
  void setMaxTdsValue(double value) {
    maxTdsValue.value = value;
  }
}