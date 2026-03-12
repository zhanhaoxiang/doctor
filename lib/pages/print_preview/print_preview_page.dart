import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class PrintPreviewPage extends StatelessWidget {
  const PrintPreviewPage({super.key});

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
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(child: _buildPrintSheet()),
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
              child: Text('打印预览',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.ink1)),
            ),
          ),
          GestureDetector(
            onTap: () => Get.snackbar('打印', '正在发送打印任务...', snackPosition: SnackPosition.BOTTOM),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent, borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('打印',
                  style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text('家庭病历汇总',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text('成员: 全部 · 2026年1月 - 3月 · 共6条',
                style: TextStyle(fontSize: 12, color: AppColors.ink3)),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 16),
          _SummaryRow(label: '妈妈', hospital: '北京协和医院', dept: '呼吸内科', date: '2026-03-08'),
          _SummaryRow(label: '大宝', hospital: '儿童医院', dept: '儿科', date: '2026-03-03'),
          _SummaryRow(label: '二宝', hospital: '社区医院', dept: '预防接种', date: '2026-03-01'),
          _SummaryRow(label: '爸爸', hospital: '301医院', dept: '心内科', date: '2026-02-21'),
          _SummaryRow(label: '家庭', hospital: '社区医院', dept: '全科', date: '2026-02-02'),
          _SummaryRow(label: '妈妈', hospital: '北京协和医院', dept: '呼吸内科', date: '2026-01-15'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.hospital, required this.dept, required this.date});
  final String label;
  final String hospital;
  final String dept;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.ink2)),
          ),
          Expanded(
            child: Text('$hospital · $dept',
                style: const TextStyle(fontSize: 12, color: AppColors.ink1)),
          ),
          Text(date, style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
        ],
      ),
    );
  }
}
