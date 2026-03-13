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
    final activeIndex = _items.indexWhere((e) => e.tab == activeTab);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 10 + bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / _items.length;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Animated sliding pill indicator ──────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOutCubic,
              left: activeIndex * itemWidth + itemWidth * 0.15,
              top: 0,
              width: itemWidth * 0.7,
              height: 42,
              child: _ActivePill(),
            ),

            // ── Tab items ─────────────────────────────────────────
            Row(
              children: _items.map((item) {
                final isActive = item.tab == activeTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabChanged?.call(item.tab),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      height: 56,
                      child: _DockItem(
                        icon: item.icon,
                        label: item.label,
                        isActive: isActive,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }),
    );
  }
}

// ── Active background pill ────────────────────────────────────────────────────

class _ActivePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.18),
            AppColors.accent.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

// ── Single dock item ──────────────────────────────────────────────────────────

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon with animated scale
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: isActive ? 1.12 : 1.0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) => Transform.scale(
            scale: scale,
            child: child,
          ),
          child: Icon(
            icon,
            size: 22,
            color: isActive ? AppColors.accent : const Color(0xFFBBBBC8),
          ),
        ),
        const SizedBox(height: 4),
        // Label with animated color + weight
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? AppColors.accent : const Color(0xFFBBBBC8),
            letterSpacing: isActive ? 0.2 : 0,
          ),
          child: Text(label),
        ),
        // Active dot indicator
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(top: 4),
          width: isActive ? 4.0 : 0.01,
          height: isActive ? 4.0 : 0.01,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
