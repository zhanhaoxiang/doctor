import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const _features = [
    '拍照识别病历单，自动提取就诊信息',
    'AI自动生成摘要与医嘱，快速回顾',
    '家庭成员管理，提醒复诊与用药',
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          SizedBox(height: topPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Icon(Icons.close_rounded, size: 16, color: AppColors.ink2),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutes.main),
                  child: const Text('跳过',
                      style: TextStyle(fontSize: 14, color: AppColors.ink3)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildHeroCard(),
                  const SizedBox(height: 20),
                  _buildFeatureList(),
                  const Spacer(),
                  _buildCtaRow(),
                  SizedBox(height: 16 + bottomPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.accentDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Text('🏥', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text('个人与家庭病历管理',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8),
          Text('安全存储就诊记录，AI辅助整理，\n让家人健康管理更简单',
              style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.6),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: _features
            .map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Text('✅', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(f, style: const TextStyle(fontSize: 13, color: AppColors.ink1)),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCtaRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => AppToast.show('查看使用指南'),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('了解更多',
                    style: TextStyle(fontSize: 15, color: AppColors.accent, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => Get.offAllNamed(AppRoutes.main),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('开始记录',
                    style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
