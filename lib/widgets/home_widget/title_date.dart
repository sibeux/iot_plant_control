import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';

class TitleDate extends StatelessWidget {
  const TitleDate({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttController = Get.find<MqttController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'MyPlant',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(180),
            ),
          ),
          SizedBox(width: 20.w),
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color:
                    mqttController.mqttIsConnected.value
                        ? Color(0xffd5feec)
                        : Color.fromARGB(255, 254, 213, 213),
              ),
              child: Text(
                mqttController.mqttIsConnected.value
                    ? 'MQTT Connected'
                    : 'MQTT Disconnected',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      mqttController.mqttIsConnected.value
                          ? Color.fromARGB(255, 69, 214, 149)
                          : Color.fromARGB(255, 214, 69, 69),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
