import 'dart:ui';
import 'package:get/get.dart';

/// 管理应用语言，调用 [switchLocale] 后全局立即生效，无需重启
class LocaleService extends GetxService {
  static LocaleService get to => Get.find();

  static const _defaultLocale = Locale('zh', 'CN');

  final _locale = _defaultLocale.obs;
  Locale get locale => _locale.value;

  /// 切换到指定语言，UI 立即响应
  void switchLocale(Locale newLocale) {
    _locale.value = newLocale;
    Get.updateLocale(newLocale);
    // TODO: 持久化到本地存储，例如：StorageService.to.write('locale', newLocale.toString());
  }

  void useChineseSimplified() => switchLocale(const Locale('zh', 'CN'));
  void useEnglish() => switchLocale(const Locale('en', 'US'));

  bool get isChinese => _locale.value.languageCode == 'zh';
}
