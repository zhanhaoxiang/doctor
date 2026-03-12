import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class FollowupPage extends StatelessWidget {
  const FollowupPage({super.key});

  static const _items = [
    _FollowupItem(member: '妈妈', dept: '呼吸内科', date: '2026-03-15', time: '09:30', hospital: '北京协和医院'),
    _FollowupItem(member: '爸爸', dept: '心内科', date: '2026-03-20', time: '14:00', hospital: '301医院'),
    _FollowupItem(member: '大宝', dept: '儿科', date: '2026-03-25', time: '10:00', hospital: '儿童医院'),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '复诊计划',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('添加', '添加复诊计划', snackPosition: SnackPosition.BOTTOM),
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
                child: _FollowupCard(item: _items[i]),
              ),
              childCount: _items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _FollowupItem {
  const _FollowupItem({
    required this.member, required this.dept, required this.date,
    required this.time, required this.hospital,
  });
  final String member;
  final String dept;
  final String date;
  final String time;
  final String hospital;
}

class _FollowupCard extends StatelessWidget {
  const _FollowupCard({required this.item});
  final _FollowupItem item;

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
          Row(
            children: [
              _Tag(label: item.member, bg: AppColors.tagMomBg, text: AppColors.tagMomText),
              const SizedBox(width: 6),
              _Tag(label: item.dept, bg: AppColors.accentLight, text: AppColors.accentDark),
            ],
          ),
          const SizedBox(height: 10),
          Text('${item.date} ${item.time}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.accent)),
          const SizedBox(height: 4),
          Text(item.hospital,
              style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.bg, required this.text});
  final String label;
  final Color bg;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, color: text, fontWeight: FontWeight.w500)),
    );
  }
}
