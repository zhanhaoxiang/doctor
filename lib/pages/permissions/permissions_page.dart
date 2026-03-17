import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  static const _items = [
    _PermItem(emoji: '📷', title: '相机', desc: '用于拍照识别病历单、处方和检查报告'),
    _PermItem(emoji: '🖼', title: '相册', desc: '从相册选取图片导入病历附件'),
    _PermItem(emoji: '🔔', title: '通知', desc: '发送用药提醒和复诊通知'),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '权限授权',
      trailing: GestureDetector(
        onTap: () => AppToast.show('权限说明'),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(Icons.help_outline_rounded, size: 16, color: AppColors.ink2),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PermCard(item: _items[i]),
              ),
              childCount: _items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _PermItem {
  const _PermItem({required this.emoji, required this.title, required this.desc});
  final String emoji;
  final String title;
  final String desc;
}

class _PermCard extends StatelessWidget {
  const _PermCard({required this.item});
  final _PermItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink1)),
                const SizedBox(height: 3),
                Text(item.desc,
                    style: const TextStyle(fontSize: 12, color: AppColors.ink2)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => AppToast.show('正在跳转系统设置...'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('前往授权',
                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
