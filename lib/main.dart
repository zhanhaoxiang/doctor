import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/translations/app_translations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/locale_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initServices();
  runApp(const MyApp());
}

Future<void> _initServices() async {
  await Get.putAsync(() async => LocaleService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Doctor',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      translations: AppTranslations(),
      locale: const Locale('zh', 'CN'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.main,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

