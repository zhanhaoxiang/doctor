import 'package:get/get.dart';

import 'reminders_controller.dart';

class RemindersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemindersController>(() => RemindersController());
  }
}
