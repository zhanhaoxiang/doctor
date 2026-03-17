import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class OcrReviewPage extends StatelessWidget {
  const OcrReviewPage({super.key});

  static const _fields = [
    _OcrField(label: '医院名称', value: '北京协和医院', confidence: 92),
    _OcrField(label: '科室', value: '呼吸内科', confidence: 88),
    _OcrField(label: '医嘱', value: '布洛芬10ml，每8小时一次；多饮水；3天后复诊。', confidence: 81),
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Container(
            color: AppColors.bg,
            padding: EdgeInsets.only(top: topPadding),
            child: _buildTopBar(),
          ),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _OcrFieldCard(field: _fields[i]),
                      ),
                      childCount: _fields.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
                  sliver: SliverToBoxAdapter(child: _buildImageCard()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
              child: const Icon(Icons.chevron_left_rounded, size: 20, color: AppColors.ink2),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('OCR识别确认',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.ink1)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              AppToast.success('识别结果已保存');
            },
            child: const Text('保存',
                style: TextStyle(fontSize: 15, color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_rounded, size: 28, color: AppColors.ink3),
          SizedBox(height: 8),
          Text('点击查看原图', style: TextStyle(fontSize: 13, color: AppColors.ink3)),
        ],
      ),
    );
  }
}

class _OcrField {
  const _OcrField({required this.label, required this.value, required this.confidence});
  final String label;
  final String value;
  final int confidence;
}

class _OcrFieldCard extends StatelessWidget {
  const _OcrFieldCard({required this.field});
  final _OcrField field;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(field.label,
                  style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${field.confidence}%',
                    style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(field.value,
              style: const TextStyle(fontSize: 14, color: AppColors.ink1)),
        ],
      ),
    );
  }
}
