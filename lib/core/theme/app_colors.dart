import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // 主色调
  static const accent = Color(0xFF2DBD6E);
  static const accentLight = Color(0xFFE6F6ED);
  static const accentDark = Color(0xFF1B6A3D);

  // 文字色
  static const ink1 = Color(0xFF1C1C1E);
  static const ink2 = Color(0xFF2C2C2E);
  static const ink3 = Color(0xFF8A8A8F);

  // 背景 & 边框
  static const bg = Color(0xFFF4F5F7);
  static const card = Colors.white;
  static const line = Color(0x0F000000); // rgba(0,0,0,0.06)

  // 家庭成员主题色（用于时间线卡片左边框）
  static const memberOrange = Color(0xFFFF9F0A); // 妈妈
  static const memberBlue = Color(0xFF32ADE6);   // 爸爸
  static const memberPurple = Color(0xFFAF52DE); // 大宝

  // 家庭成员标签背景 & 文字色
  static const tagMomBg = Color(0xFFFFF3E0);
  static const tagMomText = Color(0xFFD97706);
  static const tagDadBg = Color(0xFFE0F2FE);
  static const tagDadText = Color(0xFF0284C7);
  static const tagChild1Bg = Color(0xFFF3E8FF);
  static const tagChild1Text = Color(0xFF7C3AED);
  static const tagChild2Bg = Color(0xFFE6F6ED);
  static const tagChild2Text = Color(0xFF1B6A3D);
}
