import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'core/theme/app_theme.dart';
import 'core/translations/app_translations.dart';
import 'data/repositories/local_data_repository.dart';
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
  await Get.putAsync(() async => LocalDataRepository().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: GetMaterialApp(
      title: 'Doctor',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      translations: AppTranslations(),
      locale: const Locale('zh', 'CN'),
      fallbackLocale: const Locale('en', 'US'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
      initialRoute: AppRoutes.main,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      ),
    );
  }
}
