import 'package:get/get.dart';
import 'attachments_controller.dart';

class AttachmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttachmentsController>(() => AttachmentsController());
  }
}
