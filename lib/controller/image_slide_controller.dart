import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageSlideController extends GetxController{
  var currentIndex = 0.obs;
  var pageController = PageController().obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    pageController.value.addListener(() {
      currentIndex.value = pageController.value.page!.round();
    });
  }

  @override
  void onClose() {
    pageController.value.dispose();
    super.onClose();
  }
}