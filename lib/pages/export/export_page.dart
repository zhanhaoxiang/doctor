import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  static const _items = [
    _ExportItem(label: '导出当前成员病历为PDF', btnLabel: '生成'),
    _ExportItem(label: '导出全部记录为CSV', btnLabel: '生成'),
    _ExportItem(label: 'iCloud 备份', btnLabel: '启用'),
    _ExportItem(label: '本地加密备份', btnLabel: '设置'),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '导出与备份',
      trailing: GestureDetector(
        onTap: () => AppToast.show('正在备份...'),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(Icons.cloud_upload_outlined, size: 16, color: AppColors.ink2),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ExportCard(item: _items[i]),
              ),
              childCount: _items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExportItem {
  const _ExportItem({required this.label, required this.btnLabel});
  final String label;
  final String btnLabel;
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({required this.item});
  final _ExportItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(item.label,
                style: const TextStyle(fontSize: 14, color: AppColors.ink1)),
          ),
          GestureDetector(
            onTap: () => AppToast.show('${item.label} - 处理中...'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(item.btnLabel,
                  style: const TextStyle(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
