// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageSlideController extends GetxController {
  var currentIndex = 0.obs;
  var pageController = PageController(initialPage: 0).obs;
  // late Timer _timer;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    pageController.value.addListener(() {
      currentIndex.value = pageController.value.page!.round();
    });

    // _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
    //   if (currentIndex.value < 5 - 1) {
    //     currentIndex.value++;
    //   } else {
    //     currentIndex.value = 0;
    //   }

    //   pageController.value.animateToPage(
    //     currentIndex.value,
    //     duration: Duration(milliseconds: 500),
    //     curve: Curves.easeInOut,
    //   );
    // });
  }

  @override
  void onClose() {
    pageController.value.dispose();
    // _timer.cancel();
    super.onClose();
  }
}
