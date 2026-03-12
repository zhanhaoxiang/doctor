import 'package:get/get.dart';
import 'report_view_controller.dart';

class ReportViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportViewController>(() => ReportViewController());
  }
}
