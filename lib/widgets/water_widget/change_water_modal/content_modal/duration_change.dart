import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/water_controller.dart';

class DurationChange extends StatelessWidget {
  const DurationChange({
    super.key,
    required this.waterController,
  });

  final WaterController waterController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: TextFormField(
              textAlign: TextAlign.end,
              controller: waterController.durationController,
              onChanged: (value) {
                waterController.formatDuration(value);
              },
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 16,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              buildCounter: (
                context, {
                int? currentLength,
                int? maxLength,
                bool? isFocused,
              }) {
                return null;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Enter duration',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Obx(
            () => Text(
              int.tryParse(waterController.selectedDuration.value) == 1
                  ? ' min'
                  : ' mins',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
