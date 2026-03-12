import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '编辑病历',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('保存', '病历已保存', snackPosition: SnackPosition.BOTTOM),
        child: const Padding(
          padding: EdgeInsets.only(right: 4),
          child: Text('保存',
              style: TextStyle(fontSize: 15, color: AppColors.accent, fontWeight: FontWeight.w600)),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverToBoxAdapter(child: _buildFormCard()),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          _EditRow(label: '成员', value: '妈妈', hasChevron: true,
              onTap: () => Get.snackbar('成员', '选择家庭成员', snackPosition: SnackPosition.BOTTOM)),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          const _EditRow(label: '就诊日期', value: '2026-03-08'),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          const _EditRow(label: '医院', value: '北京协和医院'),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          const _EditRow(label: '科室', value: '呼吸内科'),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          const _EditMultiRow(label: 'AI摘要', value: '患者咳嗽2周，X线影像提示轻度炎症，无发热，血常规正常。'),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          const _EditMultiRow(label: '医嘱', value: '布洛芬10ml，每8小时一次；多饮水；3天后复诊。'),
        ],
      ),
    );
  }
}

class _EditRow extends StatelessWidget {
  const _EditRow({required this.label, required this.value, this.hasChevron = false, this.onTap});
  final String label;
  final String value;
  final bool hasChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.ink3)),
            ),
            Expanded(
              child: Text(value, style: const TextStyle(fontSize: 13, color: AppColors.ink1)),
            ),
            if (hasChevron)
              const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}

class _EditMultiRow extends StatelessWidget {
  const _EditMultiRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.ink3)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 13, color: AppColors.ink1, height: 1.6)),
        ],
      ),
    );
  }
}
