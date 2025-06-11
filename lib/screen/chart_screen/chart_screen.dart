import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/chart_controller.dart';
import 'package:iot_plant_control/widgets/chart_widget/daily_chart_sensor.dart';
import 'package:iot_plant_control/widgets/chart_widget/weekly_chart_sensor.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<ChartController>();
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text('Sensor Chart'),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(height: 0.4.h, thickness: 0.4.h),
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Weekly',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight:
                          chartController.selectedChart.value == 'weekly'
                              ? FontWeight.w600
                              : FontWeight.w600,
                      color:
                          chartController.selectedChart.value == 'weekly'
                              ? Color.fromARGB(255, 69, 214, 149)
                              : Colors.black.withAlpha(150),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Switch(
                    value: chartController.selectedChart.value == 'daily',
                    activeColor: Color.fromARGB(255, 69, 214, 149),
                    inactiveTrackColor: Colors.cyan[100],
                    onChanged: (value) {
                      chartController.selectedChart.value =
                          value ? 'daily' : 'weekly';
                    },
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Daily',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight:
                          chartController.selectedChart.value == 'daily'
                              ? FontWeight.w600
                              : FontWeight.w600,
                      color:
                          chartController.selectedChart.value == 'daily'
                              ? Color.fromARGB(255, 69, 214, 149)
                              : Colors.black.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () =>
                  chartController.selectedChart.value == 'daily'
                      ? DailyChartSensor()
                      : WeeklyChartSensor(),
            ),
          ],
        ),
      ),
    );
  }
}
