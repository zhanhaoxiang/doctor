import 'package:get/get.dart';
import 'medication_controller.dart';

class MedicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicationController>(() => MedicationController());
  }
}
