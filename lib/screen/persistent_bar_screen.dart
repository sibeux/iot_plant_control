import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/persistent_bar_controller.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class PersistentBarScreen extends StatelessWidget {
  const PersistentBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final persistentBarController = Get.put(PersistentBarController());
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Keluar dari aplikasi
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: PersistentTabView(
        tabs: persistentBarController.navBarsItems(),
        controller: persistentBarController.controller,
        navBarBuilder: (p0) {
          return Style4BottomNavBar(
            navBarDecoration: NavBarDecoration(
              padding: EdgeInsets.zero,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.2.r,
                  // blurRadius: 0.1,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(0.r),
            ),
            navBarConfig: p0,
          );
        },
        hideNavigationBar: false,
        navBarOverlap: NavBarOverlap.none(), // Biar gak nutup widget lain
        screenTransitionAnimation: ScreenTransitionAnimation(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 300),
        ),
        onTabChanged: (index) {
          persistentBarController.lastSelectedIndex = index;
        },
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: false, // Mengatur tombol back di Android
        resizeToAvoidBottomInset: true,
        stateManagement: true, // Untuk manajemen state dari tiap halaman
      ),
    );
  }
}
