import 'package:doctor/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/ark_recognition_service.dart';

class PhotoPreviewController extends GetxController {
  final imagePaths = <String>[].obs;
  final currentIndex = 0.obs;
  final isRecognizing = false.obs;
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

  Future<void> startRecognition() async {
    if (imagePaths.isEmpty || isRecognizing.value) return;
    isRecognizing.value = true;

    try {
      final result = await ArkRecognitionService.recognize(imagePaths.toList());
      isRecognizing.value = false;

      Get.toNamed(AppRoutes.edit, arguments: {'result': result, 'imagePaths': imagePaths.toList()});
    } catch (e) {
      isRecognizing.value = false;
      logger.i('Recognition error: $e');
      Get.snackbar(
        '识别失败',
        '无法连接识别服务，请检查网络后重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
