import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';

class WaterTime {
  final String id;
  String time;
  String duration;
  RxBool isActive;
  RxBool isConflict;
  RxBool isRing;

  WaterTime({
    required this.id,
    required this.time,
    required this.duration,
    bool isActive = false,
    bool isConflict = false,
    bool isRing = false,
    // }) : id = id ?? const Uuid().v4(),
  }) : isActive = isActive.obs,
       isConflict = isConflict.obs,
       isRing = isRing.obs;

  factory WaterTime.fromJson(Map<String, dynamic> json) => WaterTime(
    id: json['id'],
    time: json['time'],
    duration: json['duration'] ?? '2',
    isActive: json['isActive'] ?? false,
    isConflict: json['isConflict'] ?? false,
    isRing: json['isRing'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time,
    'duration': duration,
    'isActive': isActive.value,
    'isConflict': isConflict.value,
    'isRing': isRing.value,
  };
}
