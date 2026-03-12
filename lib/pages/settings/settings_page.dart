import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _group1 = [
    _SettingsItem(icon: Icons.upload_rounded, label: '导出与备份', route: AppRoutes.export),
    _SettingsItem(icon: Icons.label_rounded, label: '标签管理', route: AppRoutes.tags),
    _SettingsItem(icon: Icons.notifications_outlined, label: '通知中心', route: AppRoutes.notifications),
    _SettingsItem(icon: Icons.calendar_month_rounded, label: '就诊日历', route: AppRoutes.calendar),
    _SettingsItem(icon: Icons.palette_outlined, label: '主题与字体', route: null),
  ];

  static const _group2 = [
    _SettingsItem(icon: Icons.help_outline_rounded, label: '帮助与反馈', route: null),
    _SettingsItem(icon: Icons.info_outline_rounded, label: '关于', route: null),
  ];

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
            child: _buildTopBar(),
          ),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildICloudCard()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildGroup(_group1)),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  sliver: SliverToBoxAdapter(child: _buildGroup(_group2)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          _IconBtn(
            onTap: () => Get.snackbar('菜单', '打开菜单', snackPosition: SnackPosition.BOTTOM),
            child: const Icon(Icons.menu_rounded, size: 16, color: AppColors.ink2),
          ),
          const Expanded(
            child: Center(
              child: Text('设置',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.ink1)),
            ),
          ),
          _IconBtn(
            onTap: () {},
            child: const Icon(Icons.settings_rounded, size: 18, color: AppColors.ink2),
          ),
        ],
      ),
    );
  }

  Widget _buildICloudCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.cloud_rounded, size: 20, color: Color(0xFF0277BD)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('已连接 iCloud',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink1)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('已同步',
                style: TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildGroup(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _SettingsRow(item: item),
              if (i < items.length - 1)
                Divider(height: 1, thickness: 1, color: AppColors.line, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem {
  const _SettingsItem({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String? route;
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.item});
  final _SettingsItem item;

  void _onTap() {
    if (item.route != null) {
      Get.toNamed(item.route!);
    } else {
      Get.snackbar('提示', '${item.label} - coming soon', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icon, size: 16, color: AppColors.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(item.label,
                  style: const TextStyle(fontSize: 14, color: AppColors.ink1)),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

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
