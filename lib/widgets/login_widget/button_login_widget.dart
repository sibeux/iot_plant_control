import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/user_login_controller.dart';

class LoginSubmitButtonEnable extends StatelessWidget {
  const LoginSubmitButtonEnable({super.key});

  @override
  Widget build(BuildContext context) {
    final UserLoginController userLoginController = Get.put(
      UserLoginController(),
    );
    return AuthButton(
      authType: 'login',
      buttonText: 'Masuk',
      foreground: Colors.white,
      background: Color.fromARGB(255, 69, 214, 149),
      isEnable: true,
      onPressed: () {
        userLoginController.generateJwtLogin(
          username:
              userLoginController.formData['usernameLogin']!['text'].toString(),
          password:
              userLoginController.formData['passwordLogin']!['text'].toString(),
        );
      },
    );
  }
}

class LoginSubmitButtonDisable extends StatelessWidget {
  const LoginSubmitButtonDisable({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      authType: 'login',
      buttonText: 'Masuk',
      foreground: HexColor('#a8b5c8'),
      background: HexColor('#e5eaf5'),
      isEnable: false,
      onPressed: () {},
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.authType,
    required this.foreground,
    required this.background,
    required this.isEnable,
    required this.buttonText,
    required this.onPressed,
  });

  final String authType, buttonText;
  final Color foreground, background;
  final bool isEnable;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          if (isEnable) {
            onPressed();
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: background,
          elevation: 0, // Menghilangkan shadow
          splashFactory: InkRipple.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 40),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Text(
            buttonText.capitalizeFirst!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class AuthButtonLoading extends StatelessWidget {
  const AuthButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          // Do nothing
        },
        style: ElevatedButton.styleFrom(
          elevation: 0, // Menghilangkan shadow
          backgroundColor: HexColor('#fefffe'),
          splashFactory: InkRipple.splashFactory,
          side: BorderSide(
            color: Color.fromARGB(255, 69, 214, 149),
            strokeAlign: BorderSide.strokeAlignCenter,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 40),
        ),
        child: Center(
          child: Transform.scale(
            scale: 0.7,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 69, 214, 149),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
