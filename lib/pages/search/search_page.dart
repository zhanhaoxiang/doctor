import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/medical_record.dart';
import '../../routes/app_routes.dart';
import 'search_controller.dart';

class SearchPage extends GetView<RecordSearchController> {
  const SearchPage({super.key});

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
            child: _SearchTopBar(controller: controller),
          ),
          Expanded(
            child: Obx(() {
              final q = controller.query.value.trim();
              if (q.isEmpty) {
                return _QuickSearchView(controller: controller);
              }
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }
              return _ResultsView(
                results: controller.results,
                query: q,
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── 顶部搜索栏 ────────────────────────────────────────────────────────────────

class _SearchTopBar extends StatelessWidget {
  const _SearchTopBar({required this.controller});
  final RecordSearchController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          _IconBtn(
            onTap: Get.back,
            child: const Icon(Icons.chevron_left_rounded, size: 20, color: AppColors.ink2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, size: 16, color: AppColors.ink3),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 15, color: AppColors.ink1, height: 1.2),
                      decoration: const InputDecoration.collapsed(
                        hintText: '医院 / 科室 / 诊断 / 症状...',
                        hintStyle: TextStyle(fontSize: 15, color: AppColors.ink3),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.query.value.isNotEmpty
                        ? GestureDetector(
                            onTap: controller.clearQuery,
                            child: const Icon(Icons.close_rounded, size: 16, color: AppColors.ink3),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 空状态：快速搜索 ────────────────────────────────────────────────────────────

class _QuickSearchView extends StatelessWidget {
  const _QuickSearchView({required this.controller});
  final RecordSearchController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        Obx(() {
          if (controller.hospitals.isEmpty) return const SliverToBoxAdapter();
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _QuickSection(
                title: '医院',
                icon: Icons.local_hospital_rounded,
                chips: controller.hospitals,
                onTap: controller.applyQuickFilter,
              ),
            ),
          );
        }),
        Obx(() {
          if (controller.departments.isEmpty) return const SliverToBoxAdapter();
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _QuickSection(
                title: '科室',
                icon: Icons.medical_services_rounded,
                chips: controller.departments,
                onTap: controller.applyQuickFilter,
              ),
            ),
          );
        }),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _QuickSection extends StatelessWidget {
  const _QuickSection({
    required this.title,
    required this.icon,
    required this.chips,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final List<String> chips;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.ink3),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: AppColors.ink3, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips
              .take(8) // 最多显示8个快速建议
              .map(
                (label) => GestureDetector(
                  onTap: () => onTap(label),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ── 搜索结果列表 ───────────────────────────────────────────────────────────────

class _ResultsView extends StatelessWidget {
  const _ResultsView({required this.results, required this.query});

  final List<MedicalRecord> results;
  final String query;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Text(
                  '搜索结果',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink1),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${results.length}',
                    style: const TextStyle(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (results.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: const Text(
                  '未找到匹配的病历',
                  style: TextStyle(fontSize: 15, color: AppColors.ink3),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList.separated(
              itemCount: results.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _ResultCard(record: results[i], query: query),
            ),
          ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.record, required this.query});

  final MedicalRecord record;
  final String query;

  @override
  Widget build(BuildContext context) {
    final m = record.visitDate.month.toString().padLeft(2, '0');
    final d = record.visitDate.day.toString().padLeft(2, '0');
    final dateStr = '${record.visitDate.year}-$m-$d';

    final deptOrType = [record.department].whereType<String>().join(' · ');

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.detail, arguments: record.id),
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
            // 日期行
            Text(
              dateStr,
              style: const TextStyle(fontSize: 13, color: AppColors.ink3),
            ),
            const SizedBox(height: 4),
            // 医院名称（高亮关键字）
            _HighlightText(
              text: record.hospitalName,
              query: query,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ink1),
            ),
            if (deptOrType.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(deptOrType, style: const TextStyle(fontSize: 13, color: AppColors.ink3)),
            ],
            // 诊断/主诉（如有）
            if (record.diagnosis != null && record.diagnosis!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('诊断：', style: TextStyle(fontSize: 13, color: AppColors.ink3)),
                  Expanded(
                    child: _HighlightText(
                      text: record.diagnosis!,
                      query: query,
                      style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
            if (record.aiSummary.isNotEmpty) ...[
              const SizedBox(height: 4),
              _HighlightText(
                text: record.aiSummary,
                query: query,
                style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                maxLines: 2,
              ),
            ],
            // 标签行
            if (record.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: record.tags
                    .take(3)
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: tag.bgColorValue != null
                              ? Color(tag.bgColorValue!)
                              : AppColors.accentLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: tag.textColorValue != null
                                ? Color(tag.textColorValue!)
                                : AppColors.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 关键字高亮文本 ─────────────────────────────────────────────────────────────

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    this.maxLines,
  });

  final String text;
  final String query;
  final TextStyle style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }
    final lower = text.toLowerCase();
    final lowerQ = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final idx = lower.indexOf(lowerQ, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: style.copyWith(
          color: AppColors.accent,
          backgroundColor: AppColors.accentLight,
          fontWeight: FontWeight.w600,
        ),
      ));
      start = idx + query.length;
    }
    return Text.rich(
      TextSpan(children: spans, style: style),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ── 公共图标按钮 ──────────────────────────────────────────────────────────────

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
