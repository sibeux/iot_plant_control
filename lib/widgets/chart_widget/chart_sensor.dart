import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:iot_plant_control/controller/chart_controller.dart';
import 'package:iot_plant_control/widgets/chart_widget/chart_resources.dart';

class ChartSensor extends StatefulWidget {
  const ChartSensor({super.key});

  @override
  State<ChartSensor> createState() => _ChartSensorState();
}

// Definisikan di luar fungsi agar tidak dibuat ulang setiap kali build
DateTime endDate = DateTime.now();
DateTime startDate = endDate.subtract(Duration(days: 6)); // 7 hari ke belakang

List<DateTime> dateRange = List.generate(7, (index) {
  return startDate.add(Duration(days: index));
});

// Format jadi "tanggal bulan" (misal: 30 Jun, 1 Jul)
DateFormat formatter = DateFormat('d MMM', 'id'); // 'id' untuk Bahasa Indonesia
List<String> formattedDates =
    dateRange.map((date) => formatter.format(date)).toList();
List<String> _days =
    dateRange.map((date) => DateFormat('E', 'id').format(date)).toList();
// dateRange.map((date) => DateFormat('E').format(date)).toList();

class _ChartSensorState extends State<ChartSensor> {
  final chartController = Get.find<ChartController>();

  List<Color> tempGradientColors = [HexColor('#11dfa7'), HexColor('#11a7df')];
  List<Color> phGradientColors = [HexColor('#ffd500'), HexColor('#fdc500')];
  List<Color> tdsGradientColors = [HexColor('#D21312'), HexColor('#ED2B2A')];
  List<Color> kelembapanGradientColors = [
    HexColor('#0d47a1'),
    HexColor('#1565c0'),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          margin: EdgeInsets.symmetric(horizontal: 35.0.w),
          child: Obx(
            () => Stack(
              children: [
                LineChart(showAvg ? avgData() : mainData()),
                if (chartController.isLoadingFetching.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: HexColor('#11a7df'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // SizedBox(
        //   width: 60,
        //   height: 34,
        //   child: TextButton(
        //     onPressed: () {
        //       setState(() {
        //         showAvg = !showAvg;
        //       });
        //     },
        //     child: Text(
        //       'avg',
        //       style: TextStyle(
        //         fontSize: 12,
        //         color:
        //             showAvg
        //                 ? Colors.black.withValues(alpha: 0.5)
        //                 : Colors.black,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final int index = value.toInt();
    String textContent;

    // Cek apakah index valid untuk menghindari error
    if (index >= 0 && index < _days.length) {
      textContent = index == 6 ? 'Today' : formattedDates[index];
    } else {
      textContent = '';
    }

    return SideTitleWidget(
      meta: meta, // Jangan lupa teruskan properti dari meta
      child: Text(
        textContent,
        style: TextStyle(
          color: index == 6 ? HexColor('#11a7df') : Colors.black,
          fontWeight: index == 6 ? FontWeight.bold : FontWeight.normal,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(fontWeight: FontWeight.normal, fontSize: 12.sp);
    String text;
    final int index = value.toInt();

    // Cek apakah index valid untuk menghindari error
    if (index >= 0 && index < chartController.rangeY.length) {
      text = chartController.rangeY[index];
    } else {
      text = '';
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: ChartColors.mainGridLineColor, strokeWidth: 1.w);
        },
        getDrawingVerticalLine: (value) {
          return FlLine(color: ChartColors.mainGridLineColor, strokeWidth: 1.w);
        },
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.white,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final chartController = Get.find<ChartController>();
              String type =
                  spot.barIndex == 0
                      ? 'suhu'
                      : spot.barIndex == 1
                      ? 'ph'
                      : spot.barIndex == 2
                      ? 'tds'
                      : 'kelembapan';
              String value =
                  spot.x.toInt() < chartController.suhuAvgData.length
                      ? type == 'suhu'
                          ? double.parse(
                            chartController.suhuAvgData[spot.x.toInt()],
                          ).toStringAsFixed(1)
                          : type == 'ph'
                          ? double.parse(
                            chartController.phAvgData[spot.x.toInt()],
                          ).toStringAsFixed(1)
                          : type == 'tds'
                          ? double.parse(
                            chartController.tdsAvgData[spot.x.toInt()],
                          ).toStringAsFixed(1)
                          : double.parse(
                            chartController.kelembapanAvgData[spot.x.toInt()],
                          ).toStringAsFixed(1)
                      : '0.0';
              return LineTooltipItem(
                '${type.capitalize}: $value',
                TextStyle(
                  color:
                      type == 'suhu'
                          ? tempGradientColors[0]
                          : type == 'ph'
                          ? phGradientColors[0]
                          : type == 'tds'
                          ? tdsGradientColors[0]
                          : kelembapanGradientColors[0],
                  fontSize: 12.sp,
                ),
              );
            }).toList();
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30.sp,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42.sp,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 20,
      lineBarsData: [
        sensorChartBarData('suhu'),
        sensorChartBarData('ph'),
        sensorChartBarData('tds'),
        sensorChartBarData('kelembapan'),
      ],
    );
  }

  LineChartBarData sensorChartBarData(String type) {
    final chartController = Get.find<ChartController>();
    final List<FlSpot> spotList =
        type == 'suhu'
            ? chartController.suhuChartPoint
            : type == 'ph'
            ? chartController.phChartPoint
            : type == 'tds'
            ? chartController.tdsChartPoint
            : chartController.kelembapanChartPoint;
    final List<Color> gradientColors =
        type == 'suhu'
            ? tempGradientColors
            : type == 'ph'
            ? phGradientColors
            : type == 'tds'
            ? tdsGradientColors
            : kelembapanGradientColors;
    return LineChartBarData(
      show: spotList.isNotEmpty,
      spots: spotList,
      isCurved: true,
      gradient: LinearGradient(colors: gradientColors),
      barWidth: 5.w,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              gradientColors
                  .map((color) => color.withValues(alpha: 0.05))
                  .toList(),
        ),
      ),
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(
                begin: tempGradientColors[0],
                end: tempGradientColors[1],
              ).lerp(0.2)!,
              ColorTween(
                begin: tempGradientColors[0],
                end: tempGradientColors[1],
              ).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(
                  begin: tempGradientColors[0],
                  end: tempGradientColors[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
                ColorTween(
                  begin: tempGradientColors[0],
                  end: tempGradientColors[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
