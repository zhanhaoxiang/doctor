import 'package:get/get.dart';
import 'print_preview_controller.dart';

class PrintPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrintPreviewController>(() => PrintPreviewController());
  }
}
