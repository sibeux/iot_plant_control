import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/screen/home_screen/home_screen.dart';
import 'package:iot_plant_control/screen/refill_screen/refill_tandon_screen.dart';
import 'package:iot_plant_control/screen/water_screen/water_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class PersistentBarController extends GetxController {
  late PersistentTabController controller;
  int lastSelectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    controller = PersistentTabController(initialIndex: 0);
  }

  PersistentTabConfig buttonNavBar({
    required Widget screen,
    required String title,
    required IconData iconActive,
    required IconData iconInactive,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        icon: Icon(iconActive),
        inactiveIcon: Icon(iconInactive),
        title: title,
        iconSize: 20.sp,
        activeForegroundColor: Color.fromARGB(255, 69, 214, 149),
        inactiveForegroundColor: Colors.black.withAlpha(100),
      ),
    );
  }

  // Item navigasi untuk tiap tab
  List<PersistentTabConfig> navBarsItems() {
    return [
      buttonNavBar(
        screen: HomeScreen(),
        title: 'Home',
        iconActive: Icons.home,
        iconInactive: Icons.home_outlined,
      ),
      buttonNavBar(
        screen: WaterScreen(),
        title: 'Water',
        iconActive: Icons.grass_rounded,
        iconInactive: Icons.grass_outlined,
      ),
      buttonNavBar(
        screen: RefillTandonScreen(),
        title: 'Refill',
        iconActive: Icons.water_drop_rounded,
        iconInactive: Icons.water_drop_outlined,
      ),
    ];
  }
}
