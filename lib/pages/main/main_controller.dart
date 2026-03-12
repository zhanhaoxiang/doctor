import 'package:get/get.dart';

class MainController extends GetxController {
  final activeTab = 0.obs;
  void switchTab(int index) => activeTab.value = index;
}
