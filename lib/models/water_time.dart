import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';

class WaterTime {
  final String id;
  String time;
  String duration;
  RxBool isActive;

  WaterTime({
    required this.id,
    required this.time,
    required this.duration,
    bool isActive = false,
    // }) : id = id ?? const Uuid().v4(),
  }) : isActive = isActive.obs;

  factory WaterTime.fromJson(Map<String, dynamic> json) => WaterTime(
    id: json['id'],
    time: json['time'],
    duration: json['duration'] ?? '2',
    isActive: json['isActive'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time,
    'duration': duration,
    'isActive': isActive.value,
  };
}
