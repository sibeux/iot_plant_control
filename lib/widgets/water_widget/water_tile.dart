import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/models/water_time.dart';

import '../../controller/water_controller.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({super.key, required this.waterTime});

  final WaterTime waterTime;

  @override
  Widget build(BuildContext context) {
    final waterController = Get.find<WaterController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Dismissible(
        key: Key(waterTime.id.toString()),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          waterController.removeWatering(waterTime.id.toString());
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          '08:00',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                waterController
                                        .waterTime[waterController.waterTime
                                            .indexWhere(
                                              (element) =>
                                                  element.id == waterTime.id,
                                            )]
                                        .isActive
                                        .value
                                    ? Color(0xff000000)
                                    : Colors.grey.withAlpha(150),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Obx(
                    () => Text(
                      'Daily | Alarm in 9 hours 29 minutes',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color:
                            waterController
                                    .waterTime[waterController.waterTime
                                        .indexWhere(
                                          (element) =>
                                              element.id == waterTime.id,
                                        )]
                                    .isActive
                                    .value
                                ? Colors.black.withAlpha(160)
                                : Colors.grey.withAlpha(150),
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
          ),
        ),
      ),
    );
  }
}
