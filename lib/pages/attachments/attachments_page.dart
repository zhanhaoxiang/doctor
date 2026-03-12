import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class AttachmentsPage extends StatelessWidget {
  const AttachmentsPage({super.key});

  static const _attachments = [
    _Attachment(name: '胸部X线报告.jpg', type: '图片', size: '2.3 MB', isImage: true),
    _Attachment(name: '处方单.jpg', type: '图片', size: '1.1 MB', isImage: true),
    _Attachment(name: '体检报告.jpg', type: '图片', size: '3.5 MB', isImage: true),
    _Attachment(name: '病历摘要.pdf', type: 'PDF', size: '512 KB', isImage: false),
    _Attachment(name: '检查结果.pdf', type: 'PDF', size: '1.8 MB', isImage: false),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '附件',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('添加', '添加附件', snackPosition: SnackPosition.BOTTOM),
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(child: _buildGrid()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _AttachmentListRow(attachment: _attachments[i]),
              ),
              childCount: _attachments.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: _attachments.map((a) => _AttachThumb(attachment: a)).toList(),
    );
  }
}

class _Attachment {
  const _Attachment({
    required this.name, required this.type, required this.size, required this.isImage,
  });
  final String name;
  final String type;
  final String size;
  final bool isImage;
}

class _AttachThumb extends StatelessWidget {
  const _AttachThumb({required this.attachment});
  final _Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(attachment.isImage ? '📷' : '📄', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(attachment.type,
              style: const TextStyle(fontSize: 10, color: AppColors.ink3)),
        ],
      ),
    );
  }
}

class _AttachmentListRow extends StatelessWidget {
  const _AttachmentListRow({required this.attachment});
  final _Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Text(attachment.isImage ? '📷' : '📄', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(attachment.name,
                style: const TextStyle(fontSize: 13, color: AppColors.ink1)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(attachment.type,
                style: const TextStyle(fontSize: 10, color: AppColors.accentDark)),
          ),
          const SizedBox(width: 8),
          Text(attachment.size,
              style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
        ],
      ),
    );
  }
}
