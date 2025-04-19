import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/persistent_bar_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PersistentBarScreen extends StatelessWidget {
  const PersistentBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final persistentBarController = Get.put(PersistentBarController());
    return PersistentTabView(
      context,
      controller: persistentBarController.controller,
      screens: persistentBarController.buildScreens(),
      items: persistentBarController.navBarsItems(),
      onItemSelected: (index) {
        persistentBarController.lastSelectedIndex = index;
      },
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: false, // Mengatur tombol back di Android
      resizeToAvoidBottomInset: true,
      stateManagement: true, // Untuk manajemen state dari tiap halaman
      hideNavigationBarWhenKeyboardAppears: false,
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0.2.r,
            // blurRadius: 0.1,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(0.r),
        colorBehindNavBar: Colors.white,
      ),
      onWillPop: (p0) async {
        // Keluar dari aplikasi
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(false);
      },
      navBarStyle: NavBarStyle.style3,
      padding: EdgeInsets.only(bottom: 5.h),
    );
  }
}
