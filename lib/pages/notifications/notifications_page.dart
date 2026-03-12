import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../routes/app_routes.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const _items = [
    _NoticeItem(title: '大宝 · 用药提醒', body: '布洛芬10ml，每8小时一次，随餐服用', time: '5分钟前'),
    _NoticeItem(title: '妈妈 · 复诊提醒', body: '北京协和医院呼吸内科复诊，明天09:30', time: '1小时前'),
    _NoticeItem(title: '爸爸 · 用药提醒', body: '苯磺酸氨氯地平片5mg，今日晨服', time: '今天08:00'),
    _NoticeItem(title: '二宝 · 接种提醒', body: '疫苗接种计划：社区医院，本周内完成', time: '昨天'),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '通知中心',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('清空', '已清空所有通知', snackPosition: SnackPosition.BOTTOM),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Center(
            child: Text('清', style: TextStyle(fontSize: 12, color: AppColors.ink2, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _NoticeCard(item: _items[i]),
              ),
              childCount: _items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoticeItem {
  const _NoticeItem({required this.title, required this.body, required this.time});
  final String title;
  final String body;
  final String time;
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.item});
  final _NoticeItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.detail),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink1)),
              const SizedBox(height: 4),
              Text(item.body, style: const TextStyle(fontSize: 12, color: AppColors.ink2)),
              const SizedBox(height: 6),
              Text(item.time, style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
            ],
          ),
        ),
      ),
    );
  }
}
