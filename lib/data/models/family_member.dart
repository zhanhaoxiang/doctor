import 'package:flutter/material.dart';

class FamilyMember {
  final String id;
  final String name;
  /// 时间线卡片左边框颜色
  final Color accentColor;
  /// 家庭成员标签背景色
  final Color tagBgColor;
  /// 家庭成员标签文字色
  final Color tagTextColor;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.accentColor,
    required this.tagBgColor,
    required this.tagTextColor,
  });
}
