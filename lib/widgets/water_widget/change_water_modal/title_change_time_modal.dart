import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';

class TitleChangeTimeModal extends StatelessWidget {
  const TitleChangeTimeModal({super.key, required this.waterController, required this.waterTime});

  final WaterController waterController;
  final WaterTime waterTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                "${waterController.selectedHour.value.toString().padLeft(2, '0')}:${waterController.selectedMinute.value.toString().padLeft(2, '0')}",
              ),
            ),
            SizedBox(height: 5.h),
            Obx(
              () => Text(
                !waterTime.isActive.value
                    ? 'Off'
                    : waterController.countdownString.value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black.withAlpha(150),
                ),
              ),
            ),
          ],
        ),
        Obx(
          () => Switch(
            value: waterTime.isActive.value,
            onChanged: (value) {
              waterTime.isActive.value = value;
            },
            activeColor: Color.fromARGB(255, 69, 214, 149),
            inactiveTrackColor: Color(0xffD9D9D9),
            inactiveThumbColor: Color(0xffFFFFFF),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
