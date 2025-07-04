import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/components/toast.dart';
import 'package:iot_plant_control/controller/clock_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:iot_plant_control/widgets/water_widget/change_water_modal/change_time_modal.dart';

import '../../controller/watering_controller/water_controller.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({super.key, required this.waterTime});

  final WaterTime waterTime;

  @override
  Widget build(BuildContext context) {
    final waterController = Get.find<WaterController>();
    final clockController = Get.find<ClockController>();
    final hour = waterTime.time.split(':')[0];
    final minute = waterTime.time.split(':')[1];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Dismissible(
        key: Key(waterTime.id.toString()),
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: HexColor('#fefffe'),
                surfaceTintColor: Colors.transparent,
                title: const Text('Delete Watering Time'),
                content: const Text('Are you sure you want to delete this?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black.withAlpha(150)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: HexColor('#45D695')),
                    ),
                  ),
                ],
              );
            },
          );
        },
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
        child: Material(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior:
              Clip.antiAlias, // ✅ ini penting biar splash-nya ikut radius.
          child: InkWell(
            onTap: () {
              changeTimeModal(context, waterTime: waterTime);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(
                            () =>
                                waterController.updateRefresh.value ||
                                        !waterController.updateRefresh.value
                                    ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: waterTime.time,
                                            style: TextStyle(
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  waterController
                                                          .waterTime[waterController
                                                              .waterTime
                                                              .indexWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    waterTime
                                                                        .id,
                                                              )]
                                                          .isActive
                                                          .value
                                                      ? Color(0xff000000)
                                                      : Colors.grey.withAlpha(
                                                        150,
                                                      ),
                                            ),
                                          ),
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.baseline,
                                            baseline: TextBaseline.alphabetic,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: 5.w,
                                              ),
                                              child: Text(
                                                '${int.tryParse(waterTime.duration)} ${int.tryParse(waterTime.duration) == 1 ? 'second' : 'seconds'}',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color:
                                                      waterController
                                                              .waterTime[waterController
                                                                  .waterTime
                                                                  .indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        waterTime
                                                                            .id,
                                                                  )]
                                                              .isActive
                                                              .value
                                                          ? Colors.black
                                                              .withAlpha(200)
                                                          : Colors.grey
                                                              .withAlpha(150),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : SizedBox(),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Obx(
                        () => Text(
                          waterTime.isConflict.value
                              ? 'Conflict with other schedule'
                              : !waterTime.isActive.value
                              ? 'Off'
                              : clockController.refreshTime.value ||
                                  !clockController.refreshTime.value
                              ? waterController.getWaterTimeDifference(
                                int.parse(hour),
                                int.parse(minute),
                              )
                              : '',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color:
                                waterTime.isConflict.value
                                    ? Colors.red.withAlpha(200)
                                    : waterController
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
                    () => Opacity(
                      opacity: waterTime.isConflict.value ? 0.5 : 1.0,
                      child: Switch(
                        value: waterTime.isActive.value,
                        onChanged: (value) {
                          if (waterTime.isConflict.value) {
                            showToast(
                              'Conflict with other schedule. Please change the time',
                            );
                            return;
                          }
                          // Kalau ada return di atas, maka tidak akan lanjut ke bawah.
                          waterTime.isActive.value = value;
                          waterController.toggleWatering(
                            waterTime.id.toString(),
                            value,
                          );
                        },
                        activeColor: Color.fromARGB(255, 69, 214, 149),
                        inactiveTrackColor:
                            waterTime.isConflict.value
                                ? Colors.red.withAlpha(100)
                                : Color(0xffD9D9D9),
                        inactiveThumbColor: Color(0xffFFFFFF),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
