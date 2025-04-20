import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/water_controller.dart';
import 'package:iot_plant_control/screen/water_screen/add_water_screen.dart';
import 'package:iot_plant_control/widgets/water_widget/water_listtile.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final waterController = Get.put(WaterController());
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80.h,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: waterController.waterTime.length,
                itemBuilder: (context, index) {
                  final water = waterController.waterTime[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    child: WaterTile(
                      waterTime: water,
                      // onDelete: () => waterController.removeWatering(index),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 100.h,
            color: Color(0xfff7f7f7),
            child: Align(
              // Harus di-center agar elevatedButton tidak ngambil semua tinggi/lebar.
              alignment: Alignment.center,
              child: SizedBox(
                width: 60.sp,
                height: 60.sp,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const AddWaterScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      fullscreenDialog: true,
                      popGesture: false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 69, 214, 149),
                    elevation: 0,
                    splashFactory: InkRipple.splashFactory,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    padding: EdgeInsets.all(0),
                  ),
                  child: Icon(Icons.add, size: 30.sp, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
