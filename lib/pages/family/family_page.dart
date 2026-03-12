import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import 'family_controller.dart';

class FamilyPage extends GetView<FamilyController> {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '家庭成员',
      trailing: GestureDetector(
        onTap: () => Get.snackbar('添加', '添加家庭成员', snackPosition: SnackPosition.BOTTOM),
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
                child: _MemberCard(member: controller.members[i]),
              ),
              childCount: controller.members.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});
  final FamilyMemberData member;

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
          CircleAvatar(
            radius: 22,
            backgroundColor: member.avatarColor,
            child: Text(
              member.name[0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink1)),
                const SizedBox(height: 3),
                Text('${member.records}条记录 · ${member.followups}次复诊',
                    style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(member.badge,
                style: const TextStyle(fontSize: 11, color: AppColors.accent)),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.ink3),
        ],
      ),
    );
  }
}
