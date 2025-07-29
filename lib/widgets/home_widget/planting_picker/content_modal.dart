import 'package:flutter/material.dart';
import 'package:iot_plant_control/widgets/home_widget/planting_picker/date_picker.dart';

class ContentModal extends StatelessWidget {
  const ContentModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(mainAxisSize: MainAxisSize.min, children: [DatePicker()]),
    );
  }
}
