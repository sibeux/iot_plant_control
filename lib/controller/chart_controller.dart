import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iot_plant_control/components/colorize_terminal.dart';
import 'package:iot_plant_control/models/daily_second_sensor.dart';
import 'package:iot_plant_control/models/sensor_daily_avg.dart';

class ChartController extends GetxController {
  var isLoadingFetching = false.obs;
  RxList<SensorDailyAvg> dailyAverages = <SensorDailyAvg>[].obs;
  RxList<DailySecondSensor> dailySecondSensors = <DailySecondSensor>[].obs;

  RxString selectedChart = 'daily'.obs;

  RxList<String> suhuAvgData = <String>[].obs;
  RxList<String> phAvgData = <String>[].obs;
  RxList<String> kelembapanAvgData = <String>[].obs;
  RxList<String> tdsAvgData = <String>[].obs;

  RxList<bool> missingDates = <bool>[].obs;

  RxList<FlSpot> suhuChartPoint = <FlSpot>[].obs;
  RxList<FlSpot> phChartPoint = <FlSpot>[].obs;
  RxList<FlSpot> kelembapanChartPoint = <FlSpot>[].obs;
  RxList<FlSpot> tdsChartPoint = <FlSpot>[].obs;

  List<String> rangeY = [
    '0',
    '5',
    '7',
    '9',
    '10',
    '12',
    '14',
    '20',
    '40',
    '60',
    '80',
    '100',
    '300',
    '500',
    '700',
    '1000',
    '1200',
    '1400',
    '1600',
    '1800',
    '2000',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDailyAverages();
    getSecondlyData();
  }

  Future<void> fetchDailyAverages() async {
    isLoadingFetching.value = true;
    final response = await http.get(
      Uri.parse(
        'https://sibeux.my.id/project/mqtt-myplant-schedule/api/get_daily_avg',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      if (jsonList.isEmpty) {
        logError('No daily averages found');
        return;
      }
      dailyAverages.value =
          jsonList.map((json) => SensorDailyAvg.fromJson(json)).toList();
      logSuccess('Daily averages loaded');

      suhuAvgData.value =
          dailyAverages.map((avg) => avg.avgSuhu.toString()).toList();
      phAvgData.value =
          dailyAverages.map((avg) => avg.avgPh.toString()).toList();
      kelembapanAvgData.value =
          dailyAverages.map((avg) => avg.avgKelembaban.toString()).toList();
      tdsAvgData.value =
          dailyAverages.map((avg) => avg.avgTds.toString()).toList();

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(
        Duration(days: 6),
      ); // 7 hari ke belakang
      List<DateTime> dateRange = List.generate(7, (index) {
        return startDate.add(Duration(days: index));
      });

      // Ambil tanggal harinya saja (angka tanggal)
      List<int> dayNumbers = dateRange.map((date) => date.day).toList();

      // Find missng dates
      missingDates.value = [
        for (int i = 0; i < 7; i++)
          dailyAverages.any((avg) {
            return avg.date.day == dateRange[i].day;
          }),
      ];

      logInfo('Missing dates: $missingDates');

      suhuChartPoint.value = [
        for (int i = 0; i < dayNumbers.length; i++)
          if (missingDates[i])
            FlSpot(
              i.toDouble(),
              findSumbuY(
                dailyAverages[dailyAverages.indexWhere(
                      (avg) => avg.date.day == dayNumbers[i],
                    )]
                    .avgSuhu,
                rangeY,
              ),
            )
          else
            FlSpot(i.toDouble(), 0.0),
      ];

      phChartPoint.value = [
        for (int i = 0; i < dayNumbers.length; i++)
          if (missingDates[i])
            FlSpot(
              i.toDouble(),
              findSumbuY(
                dailyAverages[dailyAverages.indexWhere(
                      (avg) => avg.date.day == dayNumbers[i],
                    )]
                    .avgPh,
                rangeY,
              ),
            )
          else
            FlSpot(i.toDouble(), 0.0),
      ];

      kelembapanChartPoint.value = [
        for (int i = 0; i < dayNumbers.length; i++)
          if (missingDates[i])
            FlSpot(
              i.toDouble(),
              findSumbuY(
                dailyAverages[dailyAverages.indexWhere(
                      (avg) => avg.date.day == dayNumbers[i],
                    )]
                    .avgKelembaban,
                rangeY,
              ),
            )
          else
            FlSpot(i.toDouble(), 0.0),
      ];

      tdsChartPoint.value = [
        for (int i = 0; i < dayNumbers.length; i++)
          if (missingDates[i])
            FlSpot(
              i.toDouble(),
              findSumbuY(
                dailyAverages[dailyAverages.indexWhere(
                      (avg) => avg.date.day == dayNumbers[i],
                    )]
                    .avgTds,
                rangeY,
              ),
            )
          else
            FlSpot(i.toDouble(), 0.0),
      ];

      isLoadingFetching.value = false;
    } else {
      throw Exception('Failed to load daily averages');
    }
  }

  Future<void> getSecondlyData() async {
    isLoadingFetching.value = true;

    try {
      final url =
          'https://sibeux.my.id/project/mqtt-myplant-schedule/api/get_secondly_data';

      final response = await GetConnect().get(url);

      if (response.status.hasError) {
        throw Exception('Failed to load secondly data');
      }

      final List<dynamic> jsonData = json.decode(response.bodyString!);
      if (jsonData.isEmpty) {
        logError('No secondly data found');
        isLoadingFetching.value = false;
        return;
      }

      dailySecondSensors.value = jsonData.map((json) => DailySecondSensor.fromJson(json)).toList();

      logSuccess('Secondly data loaded successfully');
    } catch (e) {
      logError('Error fetching secondly data: $e');
      isLoadingFetching.value = false;
      return;
    } finally {
      isLoadingFetching.value = false;
    }
  }

  double findSumbuY(double value, List<String> listRangeValue) {
    List<double> rangeValues = listRangeValue.map(double.parse).toList();

    // Jika kurang dari range, letakkan di paling awal (index 0.0)
    if (value <= rangeValues.first) {
      return 0.0;
    }

    for (int i = 0; i < rangeValues.length - 1; i++) {
      double minY = rangeValues[i];
      double maxY = rangeValues[i + 1];

      if (value >= minY && value <= maxY) {
        double ratio = (value - minY) / (maxY - minY);
        return i + ratio;
      }
    }

    // Jika melebihi range, letakkan di akhir index terakhir (misal 5.0 untuk index 5)
    return (rangeValues.length - 1).toDouble();
  }
}
