import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  static const _tags = [
    '#妈妈', '#爸爸', '#大宝', '#二宝',
    '#门诊', '#复诊', '#影像', '#体检',
    '#呼吸内科', '#心内科', '#儿科', '#全科',
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '标签管理',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('添加', '添加新标签', snackPosition: SnackPosition.BOTTOM),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(Icons.add_rounded, size: 18, color: AppColors.ink2),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _tags.map((tag) => _TagChip(label: tag)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 12, color: AppColors.ink2)),
    );
  }
}
