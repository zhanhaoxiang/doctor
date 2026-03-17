import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  static const _results = [
    _SearchResult(
      date: '2026-03-08',
      hospital: '北京协和医院',
      dept: '呼吸内科 · 门诊',
      summary: 'AI摘要：咳嗽2周，影像提示轻度炎症，医嘱按时用药，3天后复诊。',
      member: '妈妈',
      type: '门诊',
    ),
    _SearchResult(
      date: '2026-03-03',
      hospital: '儿童医院',
      dept: '儿科 · 复诊',
      summary: 'AI摘要：发热38.5°C，咽部充血，布洛芬退热，多饮水，2日后复查。',
      member: '大宝',
      type: '复诊',
    ),
    _SearchResult(
      date: '2026-02-21',
      hospital: '301医院',
      dept: '心内科 · 门诊',
      summary: 'AI摘要：血压波动，心电图无明显异常，调整降压药剂量，记录血压。',
      member: '爸爸',
      type: '门诊',
    ),
  ];

  static const _filterChips = ['时间范围', '家庭成员', '就诊类型', '科室'];

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
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildSearchBar()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildFilterGrid()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        const Text('搜索结果',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink1)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_results.length}',
                            style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ResultCard(result: _results[i]),
                      ),
                      childCount: _results.length,
                    ),
                  ),
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
          _IconBtn(
            onTap: () => AppToast.show('打开菜单'),
            child: const Icon(Icons.menu_rounded, size: 16, color: AppColors.ink2),
          ),
          const Expanded(
            child: Center(
              child: Text('搜索',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.ink1)),
            ),
          ),
          _IconBtn(
            onTap: () {},
            child: const Icon(Icons.search_rounded, size: 18, color: AppColors.ink2),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 16, color: AppColors.ink3),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('输入医院/科室/症状...',
                style: TextStyle(fontSize: 14, color: AppColors.ink3)),
          ),
          const Text('筛选', style: TextStyle(fontSize: 13, color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildFilterGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _filterChips.map((label) => _FilterChip(label: label)).toList(),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
          style: BorderStyle.solid,
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.accent)),
    );
  }
}

class _SearchResult {
  const _SearchResult({
    required this.date,
    required this.hospital,
    required this.dept,
    required this.summary,
    required this.member,
    required this.type,
  });
  final String date;
  final String hospital;
  final String dept;
  final String summary;
  final String member;
  final String type;
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final _SearchResult result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.detail),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: const BorderSide(color: AppColors.accent, width: 4),
            top: BorderSide(color: AppColors.line),
            right: BorderSide(color: AppColors.line),
            bottom: BorderSide(color: AppColors.line),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(result.date,
                    style: const TextStyle(fontSize: 11, color: AppColors.ink3)),
                const Spacer(),
                const Icon(Icons.more_horiz_rounded, size: 16, color: AppColors.ink3),
              ],
            ),
            const SizedBox(height: 6),
            Text(result.hospital,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink1)),
            Text(result.dept,
                style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
            const SizedBox(height: 6),
            Text(result.summary,
                style: const TextStyle(fontSize: 12, color: AppColors.ink2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              children: [
                _Tag(label: result.member, bg: AppColors.accentLight, text: AppColors.accent),
                const SizedBox(width: 6),
                _Tag(label: result.type, bg: const Color(0xFFF0F0F0), text: AppColors.ink3),
              ],
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, color: text, fontWeight: FontWeight.w500)),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.line),
        ),
        child: Center(child: child),
      ),
    );
  }
}
