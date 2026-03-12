import 'package:get/get.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_page.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
