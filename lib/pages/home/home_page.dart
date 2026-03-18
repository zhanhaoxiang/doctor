import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import 'home_controller.dart';
import 'widgets/capture_card.dart';
import 'widgets/family_chips_bar.dart';
import 'widgets/reminder_banner.dart';
import 'widgets/timeline_section.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Container(
            color: AppColors.bg,
            padding: EdgeInsets.only(top: topPadding),
            child: _TopBar(controller: controller),
          ),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 4),
                      const FamilyChipsBar(),
                      const SizedBox(height: 14),
                      const CaptureCard(),
                      const SizedBox(height: 14),
                      Obx(() {
                        return ReminderBanner(
                          appointment: controller.nextAppointment.value,
                        );
                      }),
                      const SizedBox(height: 14),
                    ]),
                  ),
                ),
                Obx(() {
                  final groups = controller.groupedRecords;
                  if (groups.isEmpty) {
                    return const SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      sliver: SliverToBoxAdapter(child: _EmptyTimelineCard()),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList.separated(
                      itemCount: groups.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (_, index) => TimelineSection(
                        monthLabel: groups[index].label,
                        records: groups[index].records,
                        memberById: controller.memberById,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          // 添加按钮
          _AddMenuButton(),
          const SizedBox(width: 8),
          // 内联搜索框
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, size: 14, color: AppColors.ink3),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: controller.searchTextController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink1,
                        height: 1.2,
                      ),
                      decoration: const InputDecoration.collapsed(
                        hintText: '搜索病历...',
                        hintStyle: TextStyle(fontSize: 14, color: AppColors.ink3),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.searchQuery.value.isNotEmpty
                        ? GestureDetector(
                            onTap: controller.clearSearch,
                            child: const Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: AppColors.ink3,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 搜索图标 → 完整搜索页
          _IconButton(
            onTap: () => Get.toNamed(AppRoutes.search),
            child: const Icon(Icons.manage_search_rounded, size: 18, color: AppColors.ink2),
          ),
          const SizedBox(width: 8),
          // 菜单 → 设置页
          _IconButton(
            onTap: () => Get.toNamed(AppRoutes.settings),
            child: const Icon(Icons.menu_rounded, size: 16, color: AppColors.ink2),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.line),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _AddMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AddAction>(
      onSelected: (action) {
        if (action == _AddAction.manual) {
          Get.toNamed(AppRoutes.edit);
        } else {
          Get.toNamed(AppRoutes.camera);
        }
      },
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      color: Colors.white,
      itemBuilder: (_) => [
        _menuItem(
          action: _AddAction.manual,
          icon: Icons.edit_note_rounded,
          label: '手动录入',
          color: AppColors.accent,
        ),
        _menuItem(
          action: _AddAction.camera,
          icon: Icons.document_scanner_rounded,
          label: '拍照录入',
          color: const Color(0xFF32ADE6),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.line),
        ),
        child: const Center(
          child: Icon(Icons.add_rounded, size: 18, color: AppColors.ink2),
        ),
      ),
    );
  }

  PopupMenuItem<_AddAction> _menuItem({
    required _AddAction action,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem(
      value: action,
      height: 46,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.ink1,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTimelineCard extends StatelessWidget {
  const _EmptyTimelineCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: const Text(
        '还没有病历记录，点击右上角开始录入。',
        style: TextStyle(fontSize: 15, color: AppColors.ink3),
      ),
    );
  }
}

enum _AddAction { manual, camera }
