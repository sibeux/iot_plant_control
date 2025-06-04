import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/tds_controller.dart';
import 'package:iot_plant_control/widgets/tds_widget/button_set.dart';

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
            'Kelembaban ${type.capitalizeFirst}',
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
                    activeColor:
                        type == 'minimum'
                            ? Color.fromARGB(255, 163, 255, 166)
                            : Color.fromARGB(255, 255, 163, 163),
                    thumbColor:
                        type == 'minimum'
                            ? HexColor('#80d756')
                            : HexColor('#d75680'),
                    inactiveColor: Colors.grey.withAlpha(100),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    value:
                        type == 'minimum'
                            ? tdsController.kelembabanValueMin.value
                            : tdsController.kelembabanValueMax.value,
                    onChanged: (value) {
                      tdsController.setKelembabanValue(value, type);
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
                color:
                    type == 'minimum'
                        ? HexColor('#80d756')
                        : HexColor('#d75680'),
              ),
              child: Obx(
                () => Text(
                  type == 'maksimum'
                      ? "${tdsController.kelembabanValueMax.value.toStringAsFixed(0)}%"
                      : "${tdsController.kelembabanValueMin.value.toStringAsFixed(0)}%",
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
        type == 'maksimum' ? Center(child: ButtonSet()) : SizedBox(),
      ],
    );
  }
}
