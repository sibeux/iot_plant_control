import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot_plant_control/controller/image_slide_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key, required this.imageSlideController});

  final ImageSlideController imageSlideController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black,
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
                'assets/img/plant/${index + 1}.png',
                fit: BoxFit.cover,
                height: 200.h,
                filterQuality: FilterQuality.high,
              );
            },
          ),
        ),
        Positioned(
          bottom: 10.h,
          left: 0.w,
          right: 0.w,
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
    );
  }
}
