import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/widgets/water_widget/change_water_modal/content_modal/duration_change.dart';
import 'package:iot_plant_control/widgets/water_widget/change_water_modal/content_modal/time_picker_change.dart';

class ContentChangeTimeModal extends StatelessWidget {
  const ContentChangeTimeModal({
    super.key,
    required this.waterController,
  });

  final WaterController waterController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimePickerChange(waterController: waterController),
        DurationChange(waterController: waterController),
      ],
    );
  }
}
