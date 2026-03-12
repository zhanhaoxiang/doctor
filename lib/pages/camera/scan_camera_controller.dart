import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ScanCameraController extends GetxController {
  final isScanning = false.obs;

  Future<void> startScan() async {
    if (isScanning.value) return;
    isScanning.value = true;

    try {
      final pictures = await CunningDocumentScanner.getPictures(
        isGalleryImportAllowed: true,
      );

      isScanning.value = false;

      if (pictures != null && pictures.isNotEmpty) {
        Get.toNamed(AppRoutes.photoPreview, arguments: pictures);
      }
    } on PlatformException catch (e) {
      isScanning.value = false;
      debugPrint('Scanner PlatformException: ${e.code} - ${e.message}');
      Get.snackbar(
        '扫描失败',
        '设备不支持文档扫描，请重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    } on Exception catch (e) {
      isScanning.value = false;
      final msg = e.toString();
      debugPrint('Scanner exception: $msg');

      if (msg.contains('Permission not granted') || msg.contains('permission')) {
        _showPermissionDialog();
      } else {
        Get.snackbar(
          '扫描失败',
          '请重试',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      }
    }
  }

  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('需要相机权限'),
        content: const Text('请在系统设置中开启相机权限，以便扫描病历单。'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // 引导用户去设置页面
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }
}
