import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClockController extends GetxController{
  var timeNotifier = ''.obs; // Observable variable to hold the time
  late Timer _timer;
  
  // Update the time every second
  void _updateTime() {
    final now = DateTime.now();
    final locale = 'id_ID'; // Can dynamically fetch this if needed
    final formatter = DateFormat.Hm(locale); // 24-hour format: HH:mm
    timeNotifier.value = formatter.format(now);
  }

  @override
  void onInit() {
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    super.onInit();
  } // Dispose of the timer when done

  @override
  void onClose() {
    _timer.cancel();
    timeNotifier.close();
    super.onClose();
  }
}