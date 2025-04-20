import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TdsController extends GetxController {
  var tdsValue = 500.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadTdsValue();
  }

  void setTdsValue(double value) {
    tdsValue.value = value;
  }

  Future<void> saveTdsValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tdsValue', tdsValue.value);
  }

  Future<void> loadTdsValue() async {
    final prefs = await SharedPreferences.getInstance();
    tdsValue.value = prefs.getDouble('tdsValue') ?? 500.0;
  }
}
