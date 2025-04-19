import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/tds_controller.dart';
import 'package:iot_plant_control/widgets/button_mix.dart';

class TdsControlSlide extends StatelessWidget {
  const TdsControlSlide({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final tdsController = Get.put(TdsController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Total Dissolved Solids ${type.capitalizeFirst}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(200),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 5.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
                ),
                child: Obx(
                  () => Slider(
                    activeColor: Color.fromARGB(255, 255, 163, 189),
                    thumbColor: HexColor('#f3516d'),
                    inactiveColor: Colors.grey.withAlpha(100),
                    min: 500,
                    max: 1500,
                    divisions: 10,
                    value: tdsController.tdsValue.value,
                    onChanged: (value) {
                      tdsController.setTdsValue(value);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 60.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: HexColor('#e95263'),
              ),
              child: Obx(
                () => Text(
                  tdsController.tdsValue.value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Center(child: ButtonMix()),
      ],
    );
  }
}
