import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/medical_record.dart';
import '../../../data/models/family_member.dart';
import 'timeline_card_item.dart';

class TimelineSection extends StatelessWidget {
  final String monthLabel;
  final List<MedicalRecord> records;
  final FamilyMember? Function(String?) memberById;

  const TimelineSection({
    super.key,
    required this.monthLabel,
    required this.records,
    required this.memberById,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 月份标题行
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthLabel,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.ink3,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${records.length} 条',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // 卡片列表
        ...records.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TimelineCardItem(
                record: r,
                member: memberById(r.familyMemberId),
              ),
            )),
      ],
    );
  }
}
