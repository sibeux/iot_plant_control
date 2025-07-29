import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/clock_controller.dart';
import 'package:iot_plant_control/widgets/home_widget/planting_picker/content_modal.dart';
import 'package:iot_plant_control/widgets/home_widget/planting_picker/title_modal.dart';

void plantingModal(BuildContext context) {
  // controller.setUpBirthDatePickerController();
  final ClockController clockController = Get.find<ClockController>();
  showDialog<bool>(
    barrierDismissible: true,
    context: context,
    barrierColor: Colors.black.withAlpha(100),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        contentPadding: EdgeInsets.only(top: 0, bottom: 15.h),
        title: TitleModal(),
        content: ContentModal(),
        // actions: <Widget>[ConfirmPickEnable()],
      );
    },
  ).then((value) async {
    if (value == true) {
      final now = DateTime.now();
      final plantingDate = DateTime.parse(clockController.tanggalTanam.value);
      final daysSince = now.difference(plantingDate).inDays + 1;
      clockController.jumlahHari.value = daysSince.toString();

      await clockController.setDatePlanting(plantingDate);
    }
  });
}
