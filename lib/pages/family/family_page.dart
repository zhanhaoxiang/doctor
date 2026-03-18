import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../core/widgets/ios_dialogs.dart';
import '../../data/models/member_summary.dart';
import 'family_controller.dart';

class FamilyPage extends GetView<FamilyController> {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '成员管理',
      trailing: GestureDetector(
        onTap: () => _showMemberDialog(context),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(Icons.add_rounded, size: 18, color: AppColors.ink2),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: Obx(() {
            if (controller.members.isEmpty) {
              return const SliverToBoxAdapter(
                child: _EmptyState(label: '暂无成员，点击右上角添加'),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((_, index) {
                final member = controller.members[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MemberCard(
                    member: member,
                    onTap: () => _showMemberDialog(context, member: member),
                  ),
                );
              }, childCount: controller.members.length),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _showMemberDialog(
    BuildContext context, {
    MemberSummary? member,
  }) async {
    final isNew = member == null;
    final name = await showIosTextInputDialog(
      title: isNew ? '新增成员' : '修改名称',
      subtitle: isNew ? '为新成员起个名字' : null,
      initialValue: member?.member.name,
      placeholder: '请输入成员名称',
      confirmText: '保存',
      maxLength: 20,
    );

    if (name == null || name.isEmpty) {
      if (name != null) {
        AppToast.show('成员名称不能为空');
      }
      return;
    }

    try {
      if (isNew) {
        await controller.addMember(name);
      } else {
        await controller.renameMember(member.member.id, name);
      }
    } catch (error) {
      AppToast.error('保存失败：$error');
    }
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member, required this.onTap});

  final MemberSummary member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: member.member.accentColor,
                child: Text(
                  member.member.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.member.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${member.records}条记录 · ${member.followups}次复诊',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: member.member.tagBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  member.badge,
                  style: TextStyle(
                    fontSize: 14,
                    color: member.member.tagTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.ink3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
