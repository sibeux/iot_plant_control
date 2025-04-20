import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/water_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';

void changeTimeModal(BuildContext context, {required WaterTime waterTime}) {
  final waterController = Get.find<WaterController>();
  final defaultToggle = waterTime.isActive.value;
  final defaultTime = waterTime.time;
  final defaultDuration = waterTime.duration;
  waterController.durationController = TextEditingController(
    text: "${int.tryParse(waterTime.duration)}",
  );
  waterController.selectedDuration.value = waterTime.duration;
  waterController.modalChangeSetTime(
    hour: int.parse(waterTime.time.split(':')[0]),
    minute: int.parse(waterTime.time.split(':')[1]),
  );
  showDialog<bool>(
    barrierDismissible: true,
    context: context,
    barrierColor: Colors.black.withAlpha(100),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: HexColor('#fefffe'),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          top: 0,
          bottom: 15.h,
        ),
        title: Row(
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
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 400.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Jam
                  SizedBox(
                    width: 100.w,
                    height: 180.h,
                    child: CupertinoPicker(
                      looping: true,
                      itemExtent: 60,
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      scrollController: waterController.hourController,
                      onSelectedItemChanged: (index) {
                        waterController.selectedHour.value = index;
                        waterController.setWaterTimeDifference(
                          waterController.selectedHour.value,
                          waterController.selectedMinute.value,
                        );
                      },
                      children: List<Widget>.generate(24, (index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        );
                      }),
                    ),
                  ),
                  Text(":", style: TextStyle(fontSize: 24.sp)),
                  // Menit
                  SizedBox(
                    width: 100.w,
                    height: 150.h,
                    child: CupertinoPicker(
                      looping: true,
                      itemExtent: 60,
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      scrollController: waterController.minuteController,
                      onSelectedItemChanged: (index) {
                        waterController.selectedMinute.value = index;
                        waterController.setWaterTimeDifference(
                          waterController.selectedHour.value,
                          waterController.selectedMinute.value,
                        );
                      },
                      children: List<Widget>.generate(60, (index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      // Agar then() di bawah bisa membedakan antara
                      // dismiss dan confirm.
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
                        'Confirm',
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
  ).then((value) {
    if (value == true) {
      if (defaultTime !=
              '${waterController.selectedHour.value.toString().padLeft(2, '0')}:${waterController.selectedMinute.value.toString().padLeft(2, '0')}' ||
          (defaultDuration != waterController.selectedDuration.value &&
              waterController.durationController.text.isNotEmpty)) {
        waterController.updateWatering(
          id: waterTime.id,
          time:
              '${waterController.selectedHour.value.toString().padLeft(2, '0')}:${waterController.selectedMinute.value.toString().padLeft(2, '0')}',
          duration:
              waterController.durationController.text.isEmpty
                  ? defaultDuration
                  : waterController.selectedDuration.value,
        );
        if (defaultToggle == false) {
          waterController.toggleWatering(waterTime.id, true);
        } else {
          waterController.toggleWatering(
            waterTime.id,
            waterTime.isActive.value,
          );
        }
      } else if (defaultToggle != waterTime.isActive.value) {
        waterController.toggleWatering(waterTime.id, waterTime.isActive.value);
      }
    } else {
      if (defaultToggle != waterTime.isActive.value) {
        waterController.toggleWatering(waterTime.id, defaultToggle);
      }
    }
  });
}
