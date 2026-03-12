import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../home/home_page.dart';
import '../home/widgets/bottom_dock.dart';
import '../reminders/reminders_page.dart';
import '../search/search_page.dart';
import '../settings/settings_page.dart';
import 'main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  static const _tabs = [
    HomePage(),
    RemindersPage(),
    SearchPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() => IndexedStack(
            index: controller.activeTab.value,
            children: _tabs,
          )),
      bottomNavigationBar: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomDock(
                activeTab: DockTab.values[controller.activeTab.value],
                onTabChanged: (tab) => controller.switchTab(tab.index),
              ),
              SizedBox(
                height: bottomPadding,
                child: const ColoredBox(color: Colors.white),
              ),
            ],
          )),
    );
  }
}
