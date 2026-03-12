import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

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
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildOcrCard()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildFormCard()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  sliver: SliverToBoxAdapter(child: _buildAttachSection()),
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
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.line),
              ),
              child: const Center(child: Icon(Icons.close_rounded, size: 16, color: AppColors.ink2)),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('新建病历',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.ink1)),
            ),
          ),
          GestureDetector(
            onTap: () => Get.snackbar('保存', '病历已保存', snackPosition: SnackPosition.BOTTOM),
            child: const Text('保存',
                style: TextStyle(fontSize: 15, color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildOcrCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Text('📷', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          const Text('拍照识别病历单',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          const SizedBox(height: 6),
          const Text('支持医院病历本、处方单、检查报告等',
              style: TextStyle(fontSize: 12, color: AppColors.ink3)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.ocrReview),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('开始拍照识别',
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
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
          _FormRow(label: '成员', value: '妈妈', hasChevron: true,
              onTap: () => Get.snackbar('成员', '选择家庭成员', snackPosition: SnackPosition.BOTTOM)),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          _FormRow(label: '就诊日期', value: '2026-03-08'),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          _FormRow(label: '医院名称', value: '北京协和医院'),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          _FormRow(label: '科室', value: '呼吸内科'),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          _FormRow(label: 'AI摘要', value: '咳嗽2周，影像提示轻度炎症...', isMultiline: true),
          Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14),
          _FormRow(label: '医嘱', value: '布洛芬10ml，每8小时一次...', isMultiline: true),
        ],
      ),
    );
  }

  Widget _buildAttachSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('附件', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink1)),
        const SizedBox(height: 10),
        Row(
          children: [
            _AttachChip(label: '报告.jpg', icon: Icons.image_rounded),
            const SizedBox(width: 8),
            _AttachChip(label: '处方.pdf', icon: Icons.picture_as_pdf_rounded),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Get.snackbar('附件', '添加附件', snackPosition: SnackPosition.BOTTOM),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accent),
                ),
                child: const Text('添加附件',
                    style: TextStyle(fontSize: 12, color: AppColors.accent)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    required this.label,
    required this.value,
    this.hasChevron = false,
    this.isMultiline = false,
    this.onTap,
  });
  final String label;
  final String value;
  final bool hasChevron;
  final bool isMultiline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: isMultiline
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, color: AppColors.ink3)),
                  const SizedBox(height: 6),
                  Text(value,
                      style: const TextStyle(fontSize: 13, color: AppColors.ink1),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              )
            : Row(
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

class _AttachChip extends StatelessWidget {
  const _AttachChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.ink3),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.ink2)),
        ],
      ),
    );
  }
}
