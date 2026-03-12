import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'home_controller.dart';
import 'widgets/bottom_dock.dart';
import 'widgets/capture_card.dart';
import 'widgets/family_chips_bar.dart';
import 'widgets/reminder_banner.dart';
import 'widgets/timeline_section.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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

          // ── 固定底部 Dock（含 Home Indicator 安全区）──────
          const BottomDock(),
          SizedBox(
            height: bottomPadding,
            child: const ColoredBox(color: Colors.white),
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
          _IconButton(
            onTap: () => Get.snackbar('添加', '新建病历记录'),
            child: const Icon(Icons.add_rounded, size: 18, color: AppColors.ink2),
          ),
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


