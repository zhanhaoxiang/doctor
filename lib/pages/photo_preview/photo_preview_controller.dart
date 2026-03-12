import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class PhotoPreviewController extends GetxController {
  final imagePaths = <String>[].obs;
  final currentIndex = 0.obs;
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is List) {
      imagePaths.value = List<String>.from(args);
    } else if (args is String) {
      imagePaths.value = [args];
    }
    pageController = PageController();
  }

  void onPageChanged(int index) => currentIndex.value = index;

  void retake() => Get.back();

  void startRecognition() {
    // 将所有图片路径传给 OCR 页面
    Get.toNamed(AppRoutes.ocrReview, arguments: imagePaths.toList());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
