import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '统计',
      trailing: GestureDetector(
        onTap: () => AppToast.show('选择时间范围'),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(Icons.arrow_drop_down_rounded, size: 20, color: AppColors.ink2),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _VisitCard(),
              const SizedBox(height: 12),
              _MemberDistCard(),
              const SizedBox(height: 12),
              _DeptCard(),
              const SizedBox(height: 12),
              _FollowupCard(),
            ]),
          ),
        ),
      ],
    );
  }
}

class _VisitCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _StatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('近3个月就诊',
              style: TextStyle(fontSize: 15, color: AppColors.ink3)),
          const SizedBox(height: 8),
          const Text('5', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          const Text('3次复诊 · 2次检查',
              style: TextStyle(fontSize: 14, color: AppColors.ink3)),
          const SizedBox(height: 12),
          _ProgressBar(value: 0.78),
        ],
      ),
    );
  }
}

class _MemberDistCard extends StatelessWidget {
  static const _data = [
    ('妈妈', 3, 0.6),
    ('爸爸', 4, 0.8),
    ('大宝', 2, 0.4),
    ('二宝', 1, 0.2),
  ];

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('成员分布', style: TextStyle(fontSize: 15, color: AppColors.ink3)),
          const SizedBox(height: 10),
          ..._data.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(d.$1, style: const TextStyle(fontSize: 14, color: AppColors.ink2)),
                    ),
                    Expanded(child: _ProgressBar(value: d.$3)),
                    const SizedBox(width: 8),
                    Text('${d.$2}次', style: const TextStyle(fontSize: 14, color: AppColors.ink3)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _DeptCard extends StatelessWidget {
  static const _depts = ['呼吸内科', '儿科', '心内科', '全科', '预防接种'];

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('常见科室', style: TextStyle(fontSize: 15, color: AppColors.ink3)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _depts.map((d) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(d, style: const TextStyle(fontSize: 14, color: AppColors.accentDark)),
                )).toList(),
          ),
        ],
      ),
    );
  }
}

class _FollowupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _StatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('待复诊提醒', style: TextStyle(fontSize: 15, color: AppColors.ink3)),
          const SizedBox(height: 8),
          const Text('2条', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.ink1)),
          const Text('最近: 3天后', style: TextStyle(fontSize: 14, color: AppColors.ink3)),
          const SizedBox(height: 12),
          _ProgressBar(value: 0.28),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        widthFactor: value,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.accentDark],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
