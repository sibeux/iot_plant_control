import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TdsController extends GetxController {
  var kelembabanValueMin = 0.0.obs;
  var kelembabanValueMax = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadKelembabanValue();
  }

  void setKelembabanValue(double value, String type) {
    if (type == 'minimum') {
      kelembabanValueMin.value = value;
    } else if (type == 'maksimum') {
      kelembabanValueMax.value = value;
    } else {
      throw ArgumentError('Invalid type: $type');
    }
  }

  Future<void> saveKelembabanValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('kelembabanValueMin', kelembabanValueMin.value);
    await prefs.setDouble('kelembabanValueMax', kelembabanValueMax.value);
  }

  Future<void> loadKelembabanValue() async {
    final prefs = await SharedPreferences.getInstance();
    kelembabanValueMin.value = prefs.getDouble('kelembabanValueMin') ?? 0.0;
    kelembabanValueMax.value = prefs.getDouble('kelembabanValueMax') ?? 0.0;
  }
}
