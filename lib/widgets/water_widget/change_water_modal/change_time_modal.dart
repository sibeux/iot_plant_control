import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/watering_controller/check_overlapping.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:iot_plant_control/widgets/water_widget/change_water_modal/button_confirm.dart';
import 'package:iot_plant_control/widgets/water_widget/change_water_modal/content_modal/content_change_time_modal.dart';
import 'package:iot_plant_control/widgets/water_widget/change_water_modal/title_change_time_modal.dart';

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
        title: TitleChangeTimeModal(
          waterController: waterController,
          waterTime: waterTime,
        ),
        content: ContentChangeTimeModal(waterController: waterController),
        actions: <Widget>[ButtonConfirm()],
      );
    },
  ).then((value) {
    if (value == true) {
      bool isConflict = false;
      // Jika ada durasi/waktu yang diubah.
      if (defaultTime !=
              '${waterController.selectedHour.value.toString().padLeft(2, '0')}:${waterController.selectedMinute.value.toString().padLeft(2, '0')}' ||
          (defaultDuration != waterController.selectedDuration.value &&
              waterController.durationController.text.isNotEmpty)) {
        final String time =
            '${waterController.selectedHour.value.toString().padLeft(2, '0')}:${waterController.selectedMinute.value.toString().padLeft(2, '0')}';
        isConflict = checkOverlapping(
          id: waterTime.id,
          newStart: DateTime.parse(
            '2023-01-01 $time:00',
          ), // Gunakan tanggal acak untuk waktu mulai
          newDuration: Duration(
            minutes: int.parse(
              waterController.durationController.text.isEmpty
                  ? defaultDuration
                  : waterController.selectedDuration.value,
            ),
          ),
          listAlarm: waterController.waterTime,
        );
        waterController.updateWatering(
          id: waterTime.id,
          time: time,
          duration:
              waterController.durationController.text.isEmpty
                  ? defaultDuration
                  : waterController.selectedDuration.value,
          isConflict: isConflict,
        );
        if (defaultToggle == false && !isConflict) {
          waterController.toggleWatering(waterTime.id, true);
        } else {
          waterController.toggleWatering(
            waterTime.id,
            waterTime.isActive.value,
          );
        }
      } else if (defaultToggle != waterTime.isActive.value) {
        // Toggle di sini berfungsi hanya untuk memanggil toast.
        if (waterTime.isConflict.value) {
          waterController.toggleWatering(waterTime.id, false);
          return;
        }
        waterController.toggleWatering(waterTime.id, waterTime.isActive.value);
      }
    } else {
      if (defaultToggle != waterTime.isActive.value) {
        waterController.toggleWatering(waterTime.id, defaultToggle);
      }
    }
  });
}
