import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../data/models/app_notification.dart';
import 'notifications_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '通知中心',
      trailing: GestureDetector(
        onTap: () async {
          await controller.clearAll();
          AppToast.success('通知列表已清空');
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Center(
            child: Text(
              '清',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.ink2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: Obx(() {
            if (controller.items.isEmpty) {
              return const SliverToBoxAdapter(child: _EmptyState());
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _NoticeCard(item: controller.items[index]),
                ),
                childCount: controller.items.length,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.ink1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.body,
              style: const TextStyle(fontSize: 12, color: AppColors.ink2),
            ),
            const SizedBox(height: 6),
            Text(
              item.relativeTime,
              style: const TextStyle(fontSize: 11, color: AppColors.ink3),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: const Text(
        '暂无通知',
        style: TextStyle(fontSize: 13, color: AppColors.ink3),
      ),
    );
  }
}
