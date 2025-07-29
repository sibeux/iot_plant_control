class WaterHistory {
  final int uid;
  final DateTime time;
  final int duration;
  final String type;

  WaterHistory({
    required this.uid,
    required this.time,
    required this.duration,
    required this.type,
  });

  // Kode gajah (cara penggunaan).
  factory WaterHistory.fromJson(Map<String, dynamic> json) {
    return WaterHistory(
      uid: json['uid'],
      time: DateTime.parse(json['time']),
      duration: json['duration'],
      type: json['type'],
    );
  }
}
