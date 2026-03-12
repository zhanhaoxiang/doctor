import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../home_controller.dart';

class FamilyChipsBar extends GetView<HomeController> {
  const FamilyChipsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedMemberIndex.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(controller.familyMembers.length, (i) {
            final member = controller.familyMembers[i];
            final isActive = selected == i;
            return GestureDetector(
              onTap: () => controller.selectMember(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(
                  right: i < controller.familyMembers.length - 1 ? 8 : 0,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? member.accentColor : AppColors.accentLight,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isActive
                        ? member.accentColor
                        : AppColors.accent.withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.white : AppColors.ink2,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
