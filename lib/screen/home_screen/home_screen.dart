import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/image_slide_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.white,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 250.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(100),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.r),
                        bottomRight: Radius.circular(30.r),
                      ),
                    ),
                    child: PageView.builder(
                      itemCount: 5,
                      controller: imageSlideController.pageController.value,
                      onPageChanged: (index) {
                        imageSlideController.onPageChanged(index);
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          'assets/img/plant/${1}.png',
                          // 'assets/img/plant/${index + 1}.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250.h,
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: imageSlideController.pageController.value,
                    count: 5,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
