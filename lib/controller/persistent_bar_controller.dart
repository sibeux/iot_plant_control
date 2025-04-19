import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/screen/home_screen/home_screen.dart';
import 'package:iot_plant_control/screen/refill_screen/refill_screen.dart';
import 'package:iot_plant_control/screen/water_screen/water_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PersistentBarController extends GetxController {
  late PersistentTabController controller;
  int lastSelectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    controller = PersistentTabController(initialIndex: 0);
  }

  PersistentBottomNavBarItem buttonNavBar({
    required String title,
    required IconData iconActive,
    required IconData iconInactive,
  }) {
    return PersistentBottomNavBarItem(
      icon: Icon(iconActive),
      inactiveIcon: Icon(iconInactive),
      title: title,
      contentPadding: 0.sp,
      iconSize: 20.sp,
      activeColorPrimary: Color.fromARGB(255, 69, 214, 149),
      inactiveColorPrimary: Colors.black.withAlpha(100),
    );
  }

  // Daftar halaman untuk tiap tab
  List<Widget> buildScreens() {
    return [HomeScreen(), WaterScreen(), RefillScreen()];
  }

  // Item navigasi untuk tiap tab
  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      buttonNavBar(
        title: 'Home',
        iconActive: Icons.home,
        iconInactive: Icons.home_outlined,
      ),
      buttonNavBar(
        title: 'Water',
        iconActive: Icons.grass_rounded,
        iconInactive: Icons.grass_outlined,
      ),
      buttonNavBar(
        title: 'Refill',
        iconActive: Icons.water_drop_rounded,
        iconInactive: Icons.water_drop_outlined,
      ),
    ];
  }
}
