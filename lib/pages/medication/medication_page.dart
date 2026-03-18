import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  static const _items = [
    _MedItem(member: '大宝', drug: '布洛芬', detail: '10ml · 每8小时一次 · 3天'),
    _MedItem(member: '妈妈', drug: '阿莫西林', detail: '500mg · 每日三次 · 7天'),
    _MedItem(member: '爸爸', drug: '苯磺酸氨氯地平片', detail: '5mg · 每日一次 · 长期'),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '用药计划',
      trailing: GestureDetector(
        onTap: () => AppToast.show('添加用药计划'),
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
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MedCard(item: _items[i]),
              ),
              childCount: _items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _MedItem {
  const _MedItem({required this.member, required this.drug, required this.detail});
  final String member;
  final String drug;
  final String detail;
}

class _MedCard extends StatelessWidget {
  const _MedCard({required this.item});
  final _MedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(item.member,
                style: const TextStyle(fontSize: 14, color: AppColors.accentDark, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 8),
          Text(item.drug,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          const SizedBox(height: 4),
          Text(item.detail,
              style: const TextStyle(fontSize: 14, color: AppColors.ink2)),
        ],
      ),
    );
  }
}
