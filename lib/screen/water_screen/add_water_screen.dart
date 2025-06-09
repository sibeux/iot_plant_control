import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/watering_controller/add_water_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/widgets/water_widget/add_water_widget/insert_duration.dart';
import 'package:iot_plant_control/widgets/water_widget/add_water_widget/time_picker.dart';

class AddWaterScreen extends StatelessWidget {
  const AddWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final waterController = Get.find<WaterController>();
    final addWaterController = Get.put(AddWaterController());
    waterController.setCurrentTime();
    waterController.selectedDuration.value = '30';
    return Scaffold(
      backgroundColor: Color(0xfffafcfe),
      appBar: AppBar(
        toolbarHeight: 80.h,
        titleSpacing: 0,
        leading: IconButton(
          padding: EdgeInsets.zero, // Hapus padding default
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
        title: Column(
          children: [
            const Text(
              'Add watering time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 3.h),
            Obx(
              () => Text(
                waterController.countdownString.value,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Get.back();
                addWaterController.addWatering();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TimePicker(waterController: waterController),
            InsertDuration(waterController: waterController),
          ],
        ),
      ),
    );
  }
}
