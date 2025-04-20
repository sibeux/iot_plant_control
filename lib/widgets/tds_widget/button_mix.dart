import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/controller/tds_controller.dart';

class ButtonMix extends StatelessWidget {
  const ButtonMix({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttController = Get.find<MqttController>();
    final tdsController = Get.find<TdsController>();
    return ElevatedButton(
      onPressed: () async {
        mqttController.publishTDS(
          'TDS: ${tdsController.tdsValue.value.toStringAsFixed(0)}',
        );
        await tdsController.saveTdsValue();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: HexColor('#e95263'),
        elevation: 0, // Menghilangkan shadow
        splashFactory: InkRipple.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        minimumSize: Size(150.w, 40.h),
      ),
      child: Text(
        'Mix TDS',
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
