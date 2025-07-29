import 'package:flutter/material.dart';
import 'package:iot_plant_control/widgets/login_widget/button_login_widget.dart';

class ConfirmPickEnable extends StatelessWidget {
  const ConfirmPickEnable({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      authType: 'saveBirthdayPick',
      buttonText: 'Select',
      foreground: Colors.white,
      background: Color.fromARGB(255, 69, 214, 149),
      isEnable: true,
      onPressed: () async {
        // Must be use Navigator.pop to return a value from the dialog
        Navigator.of(context).pop(true);
      },
    );
  }
}
