import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:iot_plant_control/controller/chart_controller.dart';
import 'package:iot_plant_control/models/daily_second_sensor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyChartSensor extends StatelessWidget {
  const DailyChartSensor({super.key});

  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<ChartController>();
    return Obx(
      () =>
          chartController.isLoadingFetching.value
              ? const Center(child: CircularProgressIndicator())
              : chartController.dailySecondSensors.isEmpty
              ? const Center(child: Text('No data available for today'))
              : Container(
                height: MediaQuery.of(context).size.height * 0.75,
                margin: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: SfCartesianChart(
                  margin: EdgeInsets.zero,
                  legend: Legend(isVisible: true),
                  // tooltipBehavior: TooltipBehavior(
                  //   enable: true,
                  //   canShowMarker: true,
                  //   activationMode: ActivationMode.singleTap,
                  // ),
                  primaryXAxis: DateTimeAxis(
                    // Set the total range of the axis to the full 24 hours of data.
                    // This allows panning and zooming out to see all data.
                    // 1. Define the full data range (24 hours)
                    maximum: chartController.dailySecondSensors.last.timestamp,
                    minimum: chartController.dailySecondSensors.first.timestamp,
                    // Set the initially visible portion of the axis to the last hour.
                    // This is what the user sees first.
                    // 2. Define the initially visible range (last 1 hour)
                    initialVisibleMinimum: chartController
                        .dailySecondSensors
                        .last
                        .timestamp
                        .subtract(const Duration(minutes: 30)),
                    initialVisibleMaximum:
                        chartController.dailySecondSensors.last.timestamp,
                    title: AxisTitle(text: 'Time'),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    intervalType: DateTimeIntervalType.minutes,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                    enablePinching: true,
                    zoomMode: ZoomMode.x,
                  ),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    tooltipSettings: const InteractiveTooltip(
                      // Mengubah format untuk menampilkan jam, menit, dan detik
                      format: 'point.x : point.y',
                      canShowMarker: true,
                    ),
                  ),
                  onTrackballPositionChanging: (TrackballArgs args) {
                    final point = args.chartPointInfo;
                    final DateTime? time = point.chartPoint?.x as DateTime?;
                    final dynamic value = point.chartPoint?.y;
                    if (time != null) {
                      point.label =
                          '${DateFormat('HH:mm:ss').format(time)} : $value';
                    }
                  },
                  // It's better to have sepa)rate Y-axes for different units
                  // but for this example, we'll keep it simple.
                  primaryYAxis: LogarithmicAxis(
                    title: AxisTitle(text: 'Value'),
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    // Suggest a number of intervals to create. This helps the axis
                    // respect the 'maximum' value more strictly.
                    maximum: 2000,
                    interval: 1,
                    // logBase itu untuk logaritmic.
                    logBase: 2,
                  ),
                  series: [
                    lineSeriesChart(
                      chartController: chartController,
                      name: 'Suhu',
                      color: HexColor('#11dfa7'),
                      yValueMapper: (data) => data.suhu,
                    ),
                    lineSeriesChart(
                      chartController: chartController,
                      name: 'TDS',
                      color: HexColor('#D21312'),
                      yValueMapper: (data) => data.tds,
                    ),
                    lineSeriesChart(
                      chartController: chartController,
                      name: 'Kelembapan',
                      yValueMapper: (data) => data.kelembaban,
                      color: HexColor('#0d47a1'),
                    ),
                    lineSeriesChart(
                      chartController: chartController,
                      name: 'pH',
                      yValueMapper: (data) => data.ph,
                      color: HexColor('#f9a825'),
                    ),
                  ],
                ),
              ),
    );
  }

  FastLineSeries<DailySecondSensor, DateTime> lineSeriesChart({
    required ChartController chartController,
    required String name,
    required Color color,
    required double Function(DailySecondSensor) yValueMapper,
  }) {
    return FastLineSeries<DailySecondSensor, DateTime>(
      name: name,
      dataSource: chartController.dailySecondSensors,
      xValueMapper: (data, _) => data.timestamp,
      yValueMapper: (data, _) => yValueMapper(data),
      enableTooltip: true,
      color: color,
    );
  }
}
