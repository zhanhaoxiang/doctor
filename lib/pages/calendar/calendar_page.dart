import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../routes/app_routes.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  static const _activeDays = {1, 8, 15, 21};
  static const _today = 15;
  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '就诊日历',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('筛选', '选择月份', snackPosition: SnackPosition.BOTTOM),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(Icons.arrow_drop_down_rounded, size: 20, color: AppColors.ink2),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(child: _buildCalendarCard()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverToBoxAdapter(child: _buildVisitCard()),
        ),
      ],
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          const Text('2026年3月',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink1)),
          const SizedBox(height: 14),
          Row(
            children: _weekdays
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d, style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          _buildDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildDaysGrid() {
    // March 2026 starts on Sunday (index 6 in Mon-Sun grid)
    const startOffset = 6;
    const totalDays = 31;
    final cells = <Widget>[];

    for (int i = 0; i < startOffset; i++) {
      cells.add(const SizedBox());
    }
    for (int d = 1; d <= totalDays; d++) {
      final isActive = _activeDays.contains(d);
      final isToday = d == _today;
      cells.add(_DayCell(day: d, isActive: isActive, isToday: isToday));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: cells,
    );
  }

  Widget _buildVisitCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.detail),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 4, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('妈妈 · 3月15日',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink1)),
                    SizedBox(height: 3),
                    Text('北京协和医院 · 呼吸内科复诊',
                        style: TextStyle(fontSize: 12, color: AppColors.ink3)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.ink3),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.isActive, required this.isToday});
  final int day;
  final bool isActive;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    FontWeight fontWeight;

    if (isToday) {
      bg = AppColors.accent;
      textColor = Colors.white;
      fontWeight = FontWeight.bold;
    } else if (isActive) {
      bg = AppColors.accent.withValues(alpha: 0.2);
      textColor = AppColors.accentDark;
      fontWeight = FontWeight.bold;
    } else {
      bg = const Color(0xFFF3F4F6);
      textColor = AppColors.ink2;
      fontWeight = FontWeight.normal;
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(fontSize: 12, color: textColor, fontWeight: fontWeight),
        ),
      ),
    );
  }
}
