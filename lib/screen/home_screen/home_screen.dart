import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/clock_controller.dart';
import 'package:iot_plant_control/controller/image_slide_controller.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/widgets/home_widget/box_monitor.dart';
import 'package:iot_plant_control/widgets/home_widget/title_date.dart';
import 'package:iot_plant_control/widgets/home_widget/image_carousel.dart';
import 'package:intl/intl.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageSlideController = Get.put(ImageSlideController());
    final clockController = Get.put(ClockController());
    final mqttController = Get.put(MqttController());
    // Set the locale to Indonesia
    var now = DateTime.now();
    var formatter = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ); // Format: Day, Date Month Year
    String formattedDate = formatter.format(now);
    return Scaffold(
      backgroundColor: Color(0xfffafcfe),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageCarousel(imageSlideController: imageSlideController),
                SizedBox(height: 10.h),
                TitleDate(formattedDate: formattedDate),
                SizedBox(height: 15.h),
                BoxMonitor(clockController: clockController, mqttController: mqttController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
