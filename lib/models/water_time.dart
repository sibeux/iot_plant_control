import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class WaterTime {
  final String id;
  final String time;
  RxBool isActive;

  WaterTime({String? id, required this.time, bool isActive = false})
    : id = id ?? const Uuid().v4(),
      isActive = isActive.obs;
}
