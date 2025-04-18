import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/clock_controller.dart';
import 'package:iot_plant_control/controller/image_slide_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
                      itemCount: 5, // Hapus ini jika tidak ingin ada batasan.
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
                          filterQuality: FilterQuality.high,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: imageSlideController.pageController.value,
                        count: 5,
                        effect: ScrollingDotsEffect(
                          activeDotColor: Colors.white,
                          dotColor: Colors.grey,
                          dotHeight: 6.h,
                          dotWidth: 6.w,
                          spacing: 6.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'MyPlant',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(180),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Color(0xffd5feec),
                      ),
                      child: Text(
                        "Fallin' awesome",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 69, 214, 149),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 59, 212, 233),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 3.r,
                        offset: Offset(0, 1.h),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40.h,
                              width: 40.w,
                              child: SvgPicture.asset(
                                'assets/img/icon/daun.svg',
                                width: 100.0.w,
                                height: 100.0.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Obx(
                              () => Text(
                                'Sensor ${clockController.timeNotifier.value} WIB',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withAlpha(200),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
