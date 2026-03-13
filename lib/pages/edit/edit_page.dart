import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../data/models/record_attachment.dart';
import 'edit_controller.dart';

class EditPage extends GetView<EditController> {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '编辑病历',
      trailing: GestureDetector(
        onTap: controller.save,
        child: const Padding(
          padding: EdgeInsets.only(right: 4),
          child: Text(
            '保存',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(child: _buildMemberRow(context)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(child: _buildBasicCard(context)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(child: _buildAiCard()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          sliver: SliverToBoxAdapter(child: _buildAttachmentsCard(context)),
        ),
      ],
    );
  }

  // ── 成员选择行 ─────────────────────────────────────────
  Widget _buildMemberRow(BuildContext context) {
    return _CardContainer(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showMemberPicker(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              const SizedBox(
                width: 72,
                child: Text('就诊成员',
                    style: TextStyle(fontSize: 13, color: AppColors.ink3)),
              ),
              Expanded(
                child: Obx(() => Text(
                      controller.selectedMember.value,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.ink1,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 16, color: AppColors.ink3),
            ],
          ),
        ),
      ),
    );
  }

  // ── 基本信息卡片（可编辑） ───────────────────────────────
  Widget _buildBasicCard(BuildContext context) {
    return _CardContainer(
      child: Column(
        children: [
          _FieldRow(
            label: '就诊日期',
            controller: controller.visitDateCtrl,
            hint: '请输入或选择日期',
            readOnly: true,
            suffix: const Icon(Icons.calendar_today_rounded,
                size: 14, color: AppColors.ink3),
            onTap: () => controller.pickDate(context),
          ),
          _divider(),
          _FieldRowWithHistory(
            label: '医院',
            controller: controller.hospitalCtrl,
            hint: '请输入或选择医院',
            history: EditController.historyHospitals,
          ),
          _divider(),
          _FieldRowWithHistory(
            label: '科室',
            controller: controller.departmentCtrl,
            hint: '请输入或选择科室',
            history: EditController.historyDepartments,
          ),
          _divider(),
          _FieldRow(
            label: '接诊医生',
            controller: controller.doctorCtrl,
            hint: '请输入医生姓名',
          ),
          _divider(),
          _FieldRow(
            label: '诊断',
            controller: controller.diagnosisCtrl,
            hint: '请输入诊断结论',
          ),
        ],
      ),
    );
  }

  // ── AI 摘要 + 医嘱（可编辑多行） ───────────────────────
  Widget _buildAiCard() {
    return _CardContainer(
      child: Column(
        children: [
          _MultiFieldRow(
            label: 'AI 摘要',
            controller: controller.summaryCtrl,
            hint: '就诊情况摘要，可手动修改',
            minLines: 3,
          ),
          _divider(),
          _MultiFieldRow(
            label: '医嘱',
            controller: controller.prescriptionCtrl,
            hint: '用药及注意事项',
            minLines: 3,
          ),
        ],
      ),
    );
  }

  // ── 附件区 ─────────────────────────────────────────────
  Widget _buildAttachmentsCard(BuildContext context) {
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Text(
              '附件',
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.ink3,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Obx(() {
            final items = controller.attachments;
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Text(
                  '暂无附件',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.ink3.withValues(alpha: 0.6)),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: items
                    .map((a) => _AttachmentTile(
                          attachment: a,
                          onRemove: () =>
                              controller.removeAttachment(a.id),
                        ))
                    .toList(),
              ),
            );
          }),
          _divider(),
          // 添加按钮行
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _AddButton(
                  icon: Icons.document_scanner_rounded,
                  label: '拍照扫描',
                  onTap: controller.addPhotoFromCamera,
                ),
                const SizedBox(width: 10),
                _AddButton(
                  icon: Icons.photo_library_rounded,
                  label: '从相册选取',
                  onTap: controller.addPhotoFromGallery,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: AppColors.line, indent: 14, endIndent: 14);

  void _showMemberPicker(BuildContext context) {
    final members = ['妈妈', '爸爸', '大宝', '小宝'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text('选择就诊成员',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink1)),
          const SizedBox(height: 8),
          ...members.map((m) => ListTile(
                title:
                    Text(m, style: const TextStyle(color: AppColors.ink1)),
                trailing: Obx(() => controller.selectedMember.value == m
                    ? const Icon(Icons.check_rounded,
                        color: AppColors.accent)
                    : const SizedBox.shrink()),
                onTap: () {
                  controller.selectedMember.value = m;
                  Get.back();
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── 可复用组件 ──────────────────────────────────────────────

class _CardContainer extends StatelessWidget {
  const _CardContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.controller,
    required this.hint,
    this.readOnly = false,
    this.suffix,
    this.onTap,
  });
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool readOnly;
  final Widget? suffix;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 13, color: AppColors.ink3)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              style: const TextStyle(fontSize: 13, color: AppColors.ink1),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.ink3.withValues(alpha: 0.6)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: suffix,
                suffixIconConstraints:
                    const BoxConstraints(maxHeight: 32, maxWidth: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MultiFieldRow extends StatelessWidget {
  const _MultiFieldRow({
    required this.label,
    required this.controller,
    required this.hint,
    this.minLines = 3,
  });
  final String label;
  final TextEditingController controller;
  final String hint;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: AppColors.ink3)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            minLines: minLines,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
                fontSize: 13, color: AppColors.ink1, height: 1.6),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.ink3.withValues(alpha: 0.6)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

/// 可输入 + 右侧历史下拉按钮
class _FieldRowWithHistory extends StatelessWidget {
  const _FieldRowWithHistory({
    required this.label,
    required this.controller,
    required this.hint,
    required this.history,
  });
  final String label;
  final TextEditingController controller;
  final String hint;
  final List<String> history;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 13, color: AppColors.ink3)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.ink1),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.ink3.withValues(alpha: 0.6)),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showHistory(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.expand_more_rounded,
                  size: 18, color: AppColors.ink3.withValues(alpha: 0.7)),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final maxHeight = MediaQuery.of(context).size.height * 0.6;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('选择$label',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink1)),
                    const Spacer(),
                    GestureDetector(
                      onTap: Get.back,
                      child: const Icon(Icons.close_rounded,
                          size: 20, color: AppColors.ink3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: history
                      .map((item) => ListTile(
                            dense: true,
                            title: Text(item,
                                style: const TextStyle(
                                    fontSize: 14, color: AppColors.ink1)),
                            trailing: controller.text == item
                                ? const Icon(Icons.check_rounded,
                                    color: AppColors.accent, size: 18)
                                : null,
                            onTap: () {
                              controller.text = item;
                              Get.back();
                            },
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}


class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile(
      {required this.attachment, required this.onRemove});
  final RecordAttachment attachment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: attachment.isImage
                    ? Image.file(
                        File(attachment.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _iconFallback(attachment),
                      )
                    : _iconFallback(attachment),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            attachment.typeLabel,
            style: const TextStyle(fontSize: 10, color: AppColors.ink3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _iconFallback(RecordAttachment a) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: a.iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(a.icon, color: a.iconColor, size: 32),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
