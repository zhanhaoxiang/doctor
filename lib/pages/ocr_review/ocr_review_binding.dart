import 'package:get/get.dart';
import 'ocr_review_controller.dart';

class OcrReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OcrReviewController>(() => OcrReviewController());
  }
}
