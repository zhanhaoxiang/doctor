import 'package:doctor/core/utils/app_toast.dart';
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
        onTap: () =>
            AppToast.show('更多操作稍后支持'),
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
              '···',
              style: TextStyle(fontSize: 14, color: AppColors.ink2),
            ),
          ),
        ),
      ),
      bottomBar: _buildBottomBar(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverToBoxAdapter(
            child: Obx(() {
              final record = controller.record.value;
              if (record == null) {
                return const _PlaceholderCard(label: '正在加载病历详情...');
              }
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
                    Text(
                      record.hospitalName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.department ?? '未填写科室',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.line),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: '就诊时间',
                      value:
                          '${record.visitDate.year}-${record.visitDate.month.toString().padLeft(2, '0')}-${record.visitDate.day.toString().padLeft(2, '0')} ${record.visitDate.hour.toString().padLeft(2, '0')}:${record.visitDate.minute.toString().padLeft(2, '0')}',
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(label: '成员', value: controller.memberName.value),
                    const SizedBox(height: 8),
                    _InfoRow(label: '主诉', value: record.complaint ?? '未填写'),
                    const SizedBox(height: 8),
                    _InfoRow(label: '诊断', value: record.diagnosis ?? '未填写'),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: 'AI摘要'),
                    const SizedBox(height: 6),
                    Text(
                      record.aiSummary,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.ink2,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: '医嘱'),
                    const SizedBox(height: 6),
                    Text(
                      record.doctorOrder.isEmpty ? '未填写' : record.doctorOrder,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.ink2,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: '标签'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: record.tags
                          .map(
                            (tag) => _Chip(
                              label: tag.label,
                              bg: tag.bgColorValue == null
                                  ? AppColors.accentLight
                                  : Color(tag.bgColorValue!),
                              text: tag.textColorValue == null
                                  ? AppColors.accentDark
                                  : Color(tag.textColorValue!),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: '附件'),
                    const SizedBox(height: 8),
                    if (record.attachments.isEmpty)
                      const Text(
                        '暂无附件',
                        style: TextStyle(fontSize: 14, color: AppColors.ink3),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: record.attachments
                            .map((item) => _AttachThumb(label: item.name))
                            .toList(),
                      ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.line),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '单号: ${record.id}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.ink3,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '来源: ${record.source}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.ink3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _ActionBtn(
            icon: Icons.edit_rounded,
            label: '编辑',
            onTap: () =>
                Get.toNamed(AppRoutes.edit, arguments: controller.recordId),
          ),
          _ActionBtn(
            icon: Icons.share_rounded,
            label: '分享',
            onTap: () => AppToast.show('分享病历功能稍后支持'),
          ),
          _ActionBtn(
            icon: Icons.notifications_outlined,
            label: '提醒',
            onTap: () => AppToast.show('可在提醒页中新增提醒'),
          ),
          _ActionBtn(
            icon: Icons.archive_outlined,
            label: '归档',
            onTap: () => AppToast.show('归档功能稍后支持'),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, color: AppColors.ink3),
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
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.ink3),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: AppColors.ink1),
          ),
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
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.ink1,
      ),
    );
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
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 14, color: text)),
    );
  }
}

class _AttachThumb extends StatelessWidget {
  const _AttachThumb({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.insert_drive_file_rounded,
            size: 20,
            color: AppColors.ink3,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppColors.ink3),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.ink2),
            ),
          ],
        ),
      ),
    );
  }
}
