import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/water_controller.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.waterController,
  });

  final WaterController waterController;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
