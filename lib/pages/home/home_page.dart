import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/translations/tr_keys.dart';
import '../../services/locale_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(TrKeys.homeTitle.tr),
        actions: [
          Obx(() {
            final isChinese = LocaleService.to.isChinese;
            return TextButton(
              onPressed: () => isChinese
                  ? LocaleService.to.useEnglish()
                  : LocaleService.to.useChineseSimplified(),
              child: Text(
                isChinese ? 'EN' : '中',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
      ),
      body: Center(
        child: Text(
          TrKeys.homeWelcome.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
