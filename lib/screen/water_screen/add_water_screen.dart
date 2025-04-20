import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/water_controller.dart';
import 'package:iot_plant_control/widgets/water_widget/add_duration_modal.dart';

class AddWaterScreen extends StatelessWidget {
  const AddWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final waterController = Get.find<WaterController>();
    waterController.setCurrentTime();
    waterController.selectedDuration.value = '2';
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
                waterController.addWatering();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
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
                        waterController.setWaterTimeDifference(
                          waterController.selectedHour.value,
                          waterController.selectedMinute.value,
                        );
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
                  Text(":", style: TextStyle(fontSize: 24.sp)),
                  // Menit
                  SizedBox(
                    width: 100.w,
                    height: 300.h,
                    child: CupertinoPicker(
                      looping: true,
                      itemExtent: 60,
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      scrollController: waterController.minuteController,
                      onSelectedItemChanged: (index) {
                        waterController.selectedMinute.value = index;
                        waterController.setWaterTimeDifference(
                          waterController.selectedHour.value,
                          waterController.selectedMinute.value,
                        );
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
            GestureDetector(
              onTap: () {
                addDurationModal(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                height: 55.h,
                decoration: BoxDecoration(
                  color: HexColor('#f0f0f0'),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${int.tryParse(waterController.selectedDuration.value)} ${int.tryParse(waterController.selectedDuration.value) == 1 ? 'minute' : 'minutes'}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black.withAlpha(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
