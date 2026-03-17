import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class ReportViewPage extends StatelessWidget {
  const ReportViewPage({super.key});

  static const _reports = [
    _Report(
      title: '胸部CT报告',
      conclusion: '双肺未见明显实质性病变，气管居中，纵隔无增宽，胸腔无积液。',
      date: '2026-03-08',
      source: '北京协和医院',
    ),
    _Report(
      title: '血常规报告',
      conclusion: '白细胞计数正常，红细胞及血红蛋白正常，血小板正常，未见明显异常。',
      date: '2026-03-08',
      source: '北京协和医院',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '检查报告',
      trailing: GestureDetector(
        onTap: () => AppToast.show('正在导出报告...'),
        child: Container(
          width: 40, height: 32,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Center(
            child: Text('导出', style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ReportCard(report: _reports[i]),
              ),
              childCount: _reports.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _Report {
  const _Report({required this.title, required this.conclusion, required this.date, required this.source});
  final String title;
  final String conclusion;
  final String date;
  final String source;
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});
  final _Report report;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(report.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          const SizedBox(height: 10),
          const Text('结论', style: TextStyle(fontSize: 12, color: AppColors.ink3)),
          const SizedBox(height: 6),
          Text(report.conclusion,
              style: const TextStyle(fontSize: 13, color: AppColors.ink2, height: 1.6)),
          const SizedBox(height: 12),
          Row(
            children: [
              _Tag(label: report.date, bg: const Color(0xFFF0F0F0), text: AppColors.ink3),
              const SizedBox(width: 6),
              _Tag(label: report.source, bg: AppColors.accentLight, text: AppColors.accentDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.bg, required this.text});
  final String label;
  final Color bg;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, color: text)),
    );
  }
}
