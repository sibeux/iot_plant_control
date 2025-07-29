import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/watering_controller/water_history_controller.dart';
import 'package:iot_plant_control/widgets/water_widget/history_water_widget/history_listcont.dart';

class HistoryWaterScreen extends StatelessWidget {
  const HistoryWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final waterHistoryController = Get.put(WaterHistoryController());
    waterHistoryController.fetchWaterHistory();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text('Riwayat Penyiraman'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
            size: 24.sp,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: HistoryListcont(),
      ),
    );
  }
}
