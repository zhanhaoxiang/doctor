import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ScanCameraController extends GetxController {
  CameraController? _cameraCtrl;

  final isInitialized = false.obs;
  final isFlashOn = false.obs;
  final isProcessing = false.obs;
  final processingStep = 0.obs;
  final hasError = false.obs;

  static const processingSteps = [
    '正在拍摄...',
    '正在识别文档边界...',
    '正在平整处理图像...',
    '处理完成',
  ];

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        hasError.value = true;
        return;
      }
      _cameraCtrl = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _cameraCtrl!.initialize();
      isInitialized.value = true;
    } catch (e) {
      hasError.value = true;
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> toggleFlash() async {
    if (_cameraCtrl == null || !isInitialized.value) return;
    isFlashOn.value = !isFlashOn.value;
    await _cameraCtrl!.setFlashMode(
      isFlashOn.value ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> capturePhoto() async {
    if (_cameraCtrl == null || !isInitialized.value || isProcessing.value) return;

    isProcessing.value = true;
    processingStep.value = 0;

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      processingStep.value = 1;

      final XFile image = await _cameraCtrl!.takePicture();

      processingStep.value = 2;
      await Future.delayed(const Duration(milliseconds: 900));

      processingStep.value = 3;
      await Future.delayed(const Duration(milliseconds: 500));

      isProcessing.value = false;

      // 关闭闪光灯再跳转
      if (isFlashOn.value) {
        await _cameraCtrl!.setFlashMode(FlashMode.off);
      }

      Get.toNamed(AppRoutes.photoPreview, arguments: image.path);
    } catch (e) {
      isProcessing.value = false;
      Get.snackbar(
        '拍摄失败',
        '请重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  CameraController get cameraCtrl => _cameraCtrl!;

  @override
  void onClose() {
    _cameraCtrl?.dispose();
    super.onClose();
  }
}
