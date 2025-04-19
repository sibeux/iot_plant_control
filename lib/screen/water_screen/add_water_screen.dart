import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/water_controller.dart';

class AddWaterScreen extends StatelessWidget {
  const AddWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final waterController = Get.find<WaterController>();
    waterController.setCurrentTime();
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
            Text(
              'Watering in 12 hours 12 minutes',
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
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
              },
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Jam
            SizedBox(
              width: 100.w,
              height: 300.h,
              child: CupertinoPicker(
                looping: true,
                itemExtent: 60,
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                scrollController: waterController.hourController,
                onSelectedItemChanged: (index) {
                  waterController.selectedHour.value = index;
                },
                children: List<Widget>.generate(24, (index) {
                  return Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: 28.sp),
                    ),
                  );
                }),
              ),
            ),
            const Text(":", style: TextStyle(fontSize: 24)),
            // Menit
            SizedBox(
              width: 100,
              height: 300,
              child: CupertinoPicker(
                looping: true,
                itemExtent: 60,
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                scrollController: waterController.minuteController,
                onSelectedItemChanged: (index) {
                  waterController.selectedMinute.value = index;
                },
                children: List<Widget>.generate(60, (index) {
                  return Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: 28.sp),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
