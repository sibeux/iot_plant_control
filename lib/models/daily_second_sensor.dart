class DailySecondSensor {
  final String id;
  final DateTime timestamp;
  final double tds;
  final double kelembaban;
  final double suhu;
  final double ph;

  DailySecondSensor({
    required this.id,
    required this.timestamp,
    required this.tds,
    required this.kelembaban,
    required this.suhu,
    required this.ph,
  });

  factory DailySecondSensor.fromJson(Map<String, dynamic> json) {
    return DailySecondSensor(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tds: double.parse(json['tds'] as String),
      kelembaban: double.parse(json['kelembaban'] as String),
      suhu: double.parse(json['suhu'] as String),
      ph: double.parse(json['ph'] as String),
    );
  }
}
