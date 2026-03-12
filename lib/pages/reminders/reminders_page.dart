import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  static const _todayItems = [
    _ReminderItem(
      title: '大宝 · 布洛芬',
      body: '每次10ml，每8小时一次，随餐服用',
      time: '08:00',
    ),
    _ReminderItem(
      title: '妈妈 · 阿莫西林',
      body: '每次500mg，每日三次，饭后服用，连续7天',
      time: '12:30',
    ),
    _ReminderItem(
      title: '爸爸 · 降压药',
      body: '苯磺酸氨氯地平片5mg，每日一次，清晨服用',
      time: '07:00',
    ),
  ];

  static const _tomorrowItems = [
    _ReminderItem(
      title: '大宝 · 复诊提醒',
      body: '儿童医院儿科复诊，携带上次处方单',
      time: '09:30',
    ),
    _ReminderItem(
      title: '妈妈 · 布洛芬',
      body: '每次10ml，每8小时一次，按需服用',
      time: '14:00',
    ),
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
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(title: '今天', count: _todayItems.length),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ReminderCard(item: _todayItems[i]),
                      ),
                      childCount: _todayItems.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(title: '明天', count: _tomorrowItems.length),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ReminderCard(item: _tomorrowItems[i]),
                      ),
                      childCount: _tomorrowItems.length,
                    ),
                  ),
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
              child: Text(
                '提醒/医嘱',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.ink1),
              ),
            ),
          ),
          _IconBtn(
            onTap: () => Get.snackbar('添加提醒', '新建提醒', snackPosition: SnackPosition.BOTTOM),
            child: const Icon(Icons.add_rounded, size: 18, color: AppColors.ink2),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink1)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _ReminderItem {
  const _ReminderItem({required this.title, required this.body, required this.time});
  final String title;
  final String body;
  final String time;
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.item});
  final _ReminderItem item;

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink1)),
              const SizedBox(height: 4),
              Text(item.body,
                  style: const TextStyle(fontSize: 12, color: AppColors.ink2)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 12, color: AppColors.ink3),
                  const SizedBox(width: 4),
                  Text(item.time,
                      style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
                ],
              ),
            ],
          ),
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
