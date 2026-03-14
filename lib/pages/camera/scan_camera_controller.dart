import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../routes/app_routes.dart';

class ScanCameraController extends GetxController {
  final isScanning = false.obs;
  final isPicking = false.obs;

  final _picker = ImagePicker();
  final _scanner = FlutterDocScanner();

  // ── 启动文档扫描仪 ──────────────────────────────────────
  Future<void> startScan() async {
    if (isScanning.value) return;
    isScanning.value = true;

    try {
      final result = await _scanner.getScannedDocumentAsImages(page: 10, imageFormat: ImageFormat.jpeg, quality: 0.92);

      isScanning.value = false;

      if (result != null && result.images.isNotEmpty) {
        Get.toNamed(AppRoutes.photoPreview, arguments: result.images);
      }
    } on DocScanException catch (e) {
      isScanning.value = false;
      debugPrint('DocScanException: ${e.code} - ${e.message}');

      if (e.code == 'PERMISSION_DENIED') {
        _showPermissionDialog();
      } else {
        Get.snackbar(
          '扫描失败',
          e.code == 'SCAN_FAILED' ? '扫描失败，请重试' : '设备不支持文档扫描，请使用相册导入',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isScanning.value = false;
      debugPrint('Scanner error: $e');
      Get.snackbar(
        '扫描失败',
        '请重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  // ── 从相册选取（支持多选）──────────────────────────────
  Future<void> pickFromGallery() async {
    if (isPicking.value) return;
    isPicking.value = true;

    try {
      final images = await _picker.pickMultiImage(imageQuality: 95);
      isPicking.value = false;

      if (images.isNotEmpty) {
        final paths = images.map((e) => e.path).toList();
        Get.toNamed(AppRoutes.photoPreview, arguments: paths);
      }
    } catch (e) {
      isPicking.value = false;
      debugPrint('Gallery pick error: $e');
      Get.snackbar(
        '选取失败',
        '无法访问相册，请检查权限',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('需要相机权限'),
        content: const Text('请在系统设置中开启相机权限，以便扫描病历单。'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(onPressed: Get.back, child: const Text('好的')),
        ],
      ),
    );
  }
}
