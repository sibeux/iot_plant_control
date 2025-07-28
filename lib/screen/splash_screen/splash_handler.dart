import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iot_plant_control/controller/jwt_controller.dart';
import 'package:iot_plant_control/screen/persistent_bar_screen.dart';
import 'package:iot_plant_control/screen/login_screen.dart';
import 'package:iot_plant_control/screen/splash_screen/splash_screen.dart';

class SplashHandler extends StatelessWidget {
  const SplashHandler({super.key});

  Future<Widget> _checkAuth() async {
    await Get.find<JwtController>().checkToken();
    final box = GetStorage();

    if (box.read('login') == true) {
      // Validasi token jika perlu (misalnya cek expiry)
      return PersistentBarScreen(
      );
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan splash Flutter (logo, loading)
          return SplashScreen();
        } else if (snapshot.hasData) {
          // Redirect ke screen sesuai hasil cek token
          return snapshot.data!;
        } else {
          // Optional: kalau ada error
          return LoginScreen();
        }
      },
    );
  }
}
