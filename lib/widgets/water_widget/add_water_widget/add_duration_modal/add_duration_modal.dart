import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/water_controller.dart';

void addDurationModal(BuildContext context) {
  final waterController = Get.find<WaterController>();
  waterController.durationController = TextEditingController(
    text: "${int.tryParse(waterController.selectedDuration.value)}",
  );
  showDialog<bool>(
    barrierDismissible: true,
    context: context,
    barrierColor: Colors.black.withAlpha(100),
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        backgroundColor: HexColor('#fefffe'),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          top: 15.h,
          bottom: 15.h,
        ),
        title: Center(
          child: Text(
            'Insert Duration',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
        content: TextField(
          controller: waterController.durationController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.none,
          onChanged: (value) => waterController.formatDuration(value),
          decoration: InputDecoration(
            hintText: 'Enter duration',
            // Beri border membulat pada TextField
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10.0.r,
              ), // Atur radius TextField
              borderSide: const BorderSide(color: Colors.blue), // Warna border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ), // Warna border saat aktif
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0.w,
              ), // Warna border saat fokus
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0.w,
              vertical: 12.0.h,
            ), // Padding di dalam TextField
          ),
          autofocus: true, // Langsung fokus ke TextField saat dialog muncul
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: 16.0.w,
          vertical: 8.0.h,
        ), // Padding untuk actions,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withAlpha(50),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (waterController.durationController.text.isEmpty ||
                          waterController.durationController.text == '0') {
                        waterController.selectedDuration.value = '1';
                      } else {
                        waterController.selectedDuration.value =
                            waterController.durationController.text;
                      }
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: HexColor('#45D695'),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
