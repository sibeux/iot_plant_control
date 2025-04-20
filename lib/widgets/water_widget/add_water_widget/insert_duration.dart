import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/water_controller.dart';
import 'package:iot_plant_control/widgets/water_widget/add_water_widget/add_duration_modal/add_duration_modal.dart';

class InsertDuration extends StatelessWidget {
  const InsertDuration({
    super.key,
    required this.waterController,
  });

  final WaterController waterController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
