import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../routes/app_routes.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '病历详情',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('操作', '更多操作', snackPosition: SnackPosition.BOTTOM),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Center(child: Text('···', style: TextStyle(fontSize: 14, color: AppColors.ink2))),
        ),
      ),
      bottomBar: _buildBottomBar(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverToBoxAdapter(child: _buildReportCard()),
        ),
      ],
    );
  }

  Widget _buildReportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.hospital.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          const SizedBox(height: 4),
          Text(controller.dept,
              style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 12),
          _InfoRow(label: '就诊时间', value: controller.visitTime),
          const SizedBox(height: 8),
          _InfoRow(label: '成员', value: controller.member),
          const SizedBox(height: 8),
          _InfoRow(label: '主诉', value: controller.complaint),
          const SizedBox(height: 8),
          _InfoRow(label: '诊断', value: controller.diagnosis),
          const SizedBox(height: 16),
          _SectionTitle(title: 'AI摘要'),
          const SizedBox(height: 6),
          Text(controller.aiSummary,
              style: const TextStyle(fontSize: 13, color: AppColors.ink2, height: 1.6)),
          const SizedBox(height: 16),
          _SectionTitle(title: '医嘱'),
          const SizedBox(height: 6),
          Text(controller.doctorOrder,
              style: const TextStyle(fontSize: 13, color: AppColors.ink2, height: 1.6)),
          const SizedBox(height: 16),
          _SectionTitle(title: '检查项目'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: controller.examItems
                .map((t) => _Chip(label: t, bg: AppColors.accentLight, text: AppColors.accentDark))
                .toList(),
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: '用药'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: controller.medications
                .map((t) => _Chip(
                      label: t,
                      bg: const Color(0xFFFFF3E0),
                      text: const Color(0xFFD97706),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: '附件'),
          const SizedBox(height: 8),
          Row(
            children: [
              _AttachThumb(label: '报告1.jpg'),
              const SizedBox(width: 10),
              _AttachThumb(label: '处方.jpg'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('单号: ${controller.recordNo}',
                  style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
              const Spacer(),
              Text('来源: ${controller.source}',
                  style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          _ActionBtn(
            icon: Icons.edit_rounded,
            label: '编辑',
            onTap: () => Get.toNamed(AppRoutes.edit),
          ),
          _ActionBtn(
            icon: Icons.share_rounded,
            label: '分享',
            onTap: () => Get.snackbar('分享', '分享病历', snackPosition: SnackPosition.BOTTOM),
          ),
          _ActionBtn(
            icon: Icons.notifications_outlined,
            label: '提醒',
            onTap: () => Get.snackbar('提醒', '设置提醒', snackPosition: SnackPosition.BOTTOM),
          ),
          _ActionBtn(
            icon: Icons.archive_outlined,
            label: '归档',
            onTap: () => Get.snackbar('归档', '已归档', snackPosition: SnackPosition.BOTTOM),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 12, color: AppColors.ink1)),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink1));
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.bg, required this.text});
  final String label;
  final Color bg;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 12, color: text)),
    );
  }
}

class _AttachThumb extends StatelessWidget {
  const _AttachThumb({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64, height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_rounded, size: 20, color: AppColors.ink3),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.ink3),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: AppColors.ink2),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.ink2)),
          ],
        ),
      ),
    );
  }
}
