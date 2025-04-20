import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class WaterTime {
  final String id;
  String time;
  RxBool isActive;

  WaterTime({String? id, required this.time, bool isActive = false})
    : id = id ?? const Uuid().v4(),
      isActive = isActive.obs;

  factory WaterTime.fromJson(Map<String, dynamic> json) => WaterTime(
  id: json['id'],
  time: json['time'],
  isActive: json['isActive'] ?? false, // ini tetap benar
);

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time,
    'isActive': isActive.value,
  };
}
