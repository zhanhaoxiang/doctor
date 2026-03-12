import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum DockTab { home, reminder, search, profile }

class BottomDock extends StatelessWidget {
  final DockTab activeTab;
  final ValueChanged<DockTab>? onTabChanged;

  const BottomDock({
    super.key,
    this.activeTab = DockTab.home,
    this.onTabChanged,
  });

  static const _items = [
    (tab: DockTab.home, icon: Icons.home_rounded, label: '首页'),
    (tab: DockTab.reminder, icon: Icons.notifications_rounded, label: '提醒'),
    (tab: DockTab.search, icon: Icons.search_rounded, label: '搜索'),
    (tab: DockTab.profile, icon: Icons.person_rounded, label: '我的'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: _items.map((item) {
          final isActive = item.tab == activeTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged?.call(item.tab),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.accent.withValues(alpha: 0.16)
                          : AppColors.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: isActive ? AppColors.accent : AppColors.ink3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? AppColors.accent : AppColors.ink3,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
