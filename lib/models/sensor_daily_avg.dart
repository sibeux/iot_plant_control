class SensorDailyAvg {
  final DateTime date;
  final double avgTds;
  final double avgKelembaban;
  final double avgSuhu;
  final double avgPh;

  SensorDailyAvg({
    required this.date,
    required this.avgTds,
    required this.avgKelembaban,
    required this.avgSuhu,
    required this.avgPh,
  });

  factory SensorDailyAvg.fromJson(Map<String, dynamic> json) {
    return SensorDailyAvg(
      date: DateTime.parse(json['date']),
      avgTds: double.parse(json['avg_tds'] as String),
      avgKelembaban: double.parse(json['avg_kelembaban'] as String),
      avgSuhu: double.parse(json['avg_suhu'] as String),
      avgPh: double.parse(json['avg_ph'] as String),
    );
  }
}
