import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/medical_record.dart';
import '../../../routes/app_routes.dart';

class TimelineCardItem extends StatelessWidget {
  const TimelineCardItem({super.key, required this.record, this.member});

  final MedicalRecord record;
  final FamilyMember? member;

  @override
  Widget build(BuildContext context) {
    final accentColor = member?.accentColor ?? AppColors.accent;

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.detail, arguments: record.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              record.hospitalName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink1,
                              ),
                            ),
                            Text(
                              record.formattedDate,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.ink3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          record.aiSummary,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.ink2,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            ...record.tags.map((tag) => _TagChip(tag: tag)),
                            if (member != null)
                              _ColoredTagChip(
                                label: '#${member!.name}',
                                bgColor: member!.tagBgColor,
                                textColor: member!.tagTextColor,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final RecordTag tag;

  @override
  Widget build(BuildContext context) {
    final hasBg = tag.bgColorValue != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: hasBg ? Color(tag.bgColorValue!) : const Color(0xFFF0F1F4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag.label,
        style: TextStyle(
          fontSize: 14,
          color: hasBg ? Color(tag.textColorValue!) : AppColors.ink3,
        ),
      ),
    );
  }
}

class _ColoredTagChip extends StatelessWidget {
  const _ColoredTagChip({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(fontSize: 14, color: textColor)),
    );
  }
}
