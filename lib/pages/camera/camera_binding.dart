import 'package:get/get.dart';
import 'scan_camera_controller.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanCameraController>(() => ScanCameraController());
  }
}
