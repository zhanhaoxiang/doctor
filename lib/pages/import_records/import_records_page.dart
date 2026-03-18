import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class ImportRecordsPage extends StatelessWidget {
  const ImportRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '数据导入',
      trailing: GestureDetector(
        onTap: () => AppToast.show('新建导入任务'),
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _ImportCard(
                title: '从健康码/医院App导入',
                subtitle: '扫描或文件导入',
                buttons: [
                  _ImportBtn(
                    label: '扫码导入',
                    onTap: () => AppToast.show('扫码导入'),
                  ),
                  _ImportBtn(
                    label: '文件导入',
                    onTap: () => AppToast.show('选择文件'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ImportCard(
                title: '导入本地文件',
                subtitle: '支持PDF/图片/CSV',
                buttons: [
                  _ImportBtn(
                    label: '选择文件',
                    onTap: () => AppToast.show('打开文件选择器'),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ImportBtn {
  const _ImportBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
}

class _ImportCard extends StatelessWidget {
  const _ImportCard({required this.title, required this.subtitle, required this.buttons});
  final String title;
  final String subtitle;
  final List<_ImportBtn> buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.ink3)),
          const SizedBox(height: 14),
          Row(
            children: buttons
                .map((b) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: b.onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(b.label,
                              style: const TextStyle(fontSize: 15, color: Colors.white)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
