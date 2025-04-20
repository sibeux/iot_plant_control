import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/clock_controller.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/widgets/home_widget/box_monitor_blpr.dart';
import 'package:iot_plant_control/widgets/tds_widget/tds_control_slide.dart';

class BoxMonitor extends StatelessWidget {
  const BoxMonitor({
    super.key,
    required this.clockController,
    required this.mqttController,
  });

  final ClockController clockController;
  final MqttController mqttController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 3.r,
              offset: Offset(0, 1.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40.h,
                    width: 40.w,
                    child: SvgPicture.asset(
                      'assets/img/icon/daun.svg',
                      width: 100.0.w,
                      height: 100.0.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Obx(
                    () => Text(
                      '${clockController.timeNotifier.value} WIB',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Obx(
                      () => BoxMonitorBlpr(
                        id: 1,
                        title: 'pH',
                        status: 'Good',
                        value: '${mqttController.phValue.value}',
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Obx(
                      () => BoxMonitorBlpr(
                        id: 2,
                        title: 'Temperature',
                        status: 'Good',
                        value:
                            '${mqttController.temperatureValue.value}°',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Obx(
                      () => BoxMonitorBlpr(
                        id: 3,
                        title: 'PPM',
                        status: 'Good',
                        value: '${mqttController.phValue.value}',
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Obx(
                      () => BoxMonitorBlpr(
                        id: 4,
                        title: 'Temperature',
                        status: 'Good',
                        value:
                            '${mqttController.temperatureValue.value}°',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              TdsControlSlide(type: ''),
            ],
          ),
        ),
      ),
    );
  }
}
