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
          // ── 固定 AppBar（含状态栏安全区）─────────────────
          Container(
            color: AppColors.bg,
            padding: EdgeInsets.only(top: topPadding),
            child: const _TopBar(),
          ),

          // ── 可滚动内容区 ─────────────────────────────────
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
                      Obx(() => ReminderBanner(
                            appointment: controller.nextAppointment.value,
                          )),
                      const SizedBox(height: 14),
                    ]),
                  ),
                ),
                // 时间线分组（响应筛选变化）
                Obx(() {
                  final groups = controller.groupedRecords;
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList.separated(
                      itemCount: groups.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (_, i) => TimelineSection(
                        monthLabel: groups[i].label,
                        records: groups[i].records,
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
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          _IconButton(
            onTap: () {},
            child: const Icon(Icons.menu_rounded, size: 16, color: AppColors.ink2),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '病历时间线',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink1,
                ),
              ),
            ),
          ),
          _AddMenuButton(),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _IconButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
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
        width: 32,
        height: 32,
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

enum _AddAction { manual, camera }



