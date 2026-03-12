import 'package:get/get.dart';
import 'import_records_controller.dart';

class ImportRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportRecordsController>(() => ImportRecordsController());
  }
}
