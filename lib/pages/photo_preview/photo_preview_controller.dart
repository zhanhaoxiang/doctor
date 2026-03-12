import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class PhotoPreviewController extends GetxController {
  final imagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final path = Get.arguments as String?;
    if (path != null) {
      imagePath.value = path;
    }
  }

  void retake() {
    Get.back();
  }

  void startRecognition() {
    Get.toNamed(AppRoutes.ocrReview, arguments: imagePath.value);
  }
}
