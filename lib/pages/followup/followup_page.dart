import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../data/models/followup_plan.dart';
import 'followup_controller.dart';

class FollowupPage extends GetView<FollowupController> {
  const FollowupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '复诊计划',
      trailing: GestureDetector(
        onTap: () => Get.snackbar(
          '提示',
          '复诊计划会根据数据库中的就诊安排自动展示',
          snackPosition: SnackPosition.BOTTOM,
        ),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.ink2,
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
                  child: _FollowupCard(item: controller.items[index]),
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

class _FollowupCard extends StatelessWidget {
  const _FollowupCard({required this.item});

  final FollowupPlan item;

  @override
  Widget build(BuildContext context) {
    final bg = item.isDefaultMember
        ? AppColors.accentLight
        : AppColors.tagDadBg;
    final text = item.isDefaultMember
        ? AppColors.accentDark
        : AppColors.tagDadText;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(label: item.memberName ?? '未指定成员', bg: bg, text: text),
              const SizedBox(width: 6),
              _Tag(
                label: item.department,
                bg: AppColors.accentLight,
                text: AppColors.accentDark,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${item.dateText} ${item.timeText}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.hospital,
            style: const TextStyle(fontSize: 12, color: AppColors.ink3),
          ),
          if ((item.note ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.note!,
              style: const TextStyle(fontSize: 12, color: AppColors.ink2),
            ),
          ],
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.bg, required this.text});

  final String label;
  final Color bg;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: text,
          fontWeight: FontWeight.w500,
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
        '暂无复诊计划',
        style: TextStyle(fontSize: 13, color: AppColors.ink3),
      ),
    );
  }
}
