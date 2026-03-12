import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class FamilyMemberData {
  const FamilyMemberData({
    required this.name,
    required this.records,
    required this.followups,
    required this.badge,
    required this.avatarColor,
    required this.tagBg,
    required this.tagText,
  });
  final String name;
  final int records;
  final int followups;
  final String badge;
  final Color avatarColor;
  final Color tagBg;
  final Color tagText;
}

class FamilyController extends GetxController {
  final members = const [
    FamilyMemberData(
      name: '妈妈', records: 3, followups: 1, badge: '本机成员',
      avatarColor: AppColors.memberOrange,
      tagBg: AppColors.tagMomBg, tagText: AppColors.tagMomText,
    ),
    FamilyMemberData(
      name: '爸爸', records: 4, followups: 2, badge: '心内科',
      avatarColor: AppColors.memberBlue,
      tagBg: AppColors.tagDadBg, tagText: AppColors.tagDadText,
    ),
    FamilyMemberData(
      name: '大宝', records: 2, followups: 0, badge: '儿科',
      avatarColor: AppColors.memberPurple,
      tagBg: AppColors.tagChild1Bg, tagText: AppColors.tagChild1Text,
    ),
    FamilyMemberData(
      name: '二宝', records: 1, followups: 0, badge: '本机成员',
      avatarColor: AppColors.accent,
      tagBg: AppColors.tagChild2Bg, tagText: AppColors.tagChild2Text,
    ),
  ];
}
