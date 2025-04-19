import 'package:get/get.dart';

class TdsController extends GetxController {
  var tdsValue = 500.0.obs;

  void setTdsValue(double value) {
    tdsValue.value = value;
  }
}
