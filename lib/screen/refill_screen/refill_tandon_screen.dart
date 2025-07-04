// Layar dengan tombol ON/OFF
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/controller/refill_tandon_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/permission_controller.dart';

class RefillTandonScreen extends StatelessWidget {
  const RefillTandonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final refillTandonController = Get.find<RefillTandonController>();
    final permissionController = Get.find<PermissionController>();
    final mqttController = Get.find<MqttController>();
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text('Refill Tandon'),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(height: 0.4.h, thickness: 0.4.h),
            Spacer(),
            SizedBox(
              width: 350.w,
              height: 350.h,
              child: Obx(
                () => Image.asset(
                  refillTandonController.isServiceRunning.value
                      ? 'assets/img/icon/water-tower.gif'
                      : 'assets/img/icon/water-tower.jpg',
                ),
              ),
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color:
                      refillTandonController.isServiceRunning.value
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  refillTandonController.isServiceRunning.value
                      ? 'Pump Status: ACTIVE'
                      : 'Pump Status: INACTIVE',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        refillTandonController.isServiceRunning.value
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Obx(
              () => AbsorbPointer(
                absorbing: !permissionController.isNotificationGranted.value,
                child: SizedBox(
                  width: 300.w,
                  child: ElevatedButton(
                    onPressed: () {
                      if (refillTandonController.isServiceRunning.value) {
                        refillTandonController.toggleService(
                          false,
                          isFromButton: true,
                        );
                        mqttController.publishToBroker('stoppengisiantandonair');
                      } else {
                        refillTandonController.toggleService(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          !permissionController.isNotificationGranted.value
                              ? Colors.grey
                              : !refillTandonController.isServiceRunning.value
                              ? Color.fromARGB(255, 69, 214, 149)
                              : HexColor('#e95263'),
                      elevation: 0, // Menghilangkan shadow
                      splashFactory: InkRipple.splashFactory,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w,
                        vertical: 10.0.h,
                      ),
                      child:
                          refillTandonController.isLoading.value
                              ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0.w,
                                ),
                              )
                              : Text(
                                !refillTandonController.isServiceRunning.value
                                    ? 'Start'
                                    : 'Stop',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}
