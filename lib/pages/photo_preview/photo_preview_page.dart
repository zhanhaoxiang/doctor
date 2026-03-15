import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'photo_preview_controller.dart';

class PhotoPreviewPage extends GetView<PhotoPreviewController> {
  const PhotoPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 多图滑动预览 ─────────────────────────────────
          Obx(() {
            if (controller.imagePaths.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.imagePaths.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 5.0,
                  child: Center(
                    child: Image.file(
                      File(controller.imagePaths[index]),
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            );
          }),

          // ── 顶部栏 ───────────────────────────────────────
          Positioned(
            top: safeTop + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Obx(() {
                      final total = controller.imagePaths.length;
                      final cur = controller.currentIndex.value + 1;
                      return Text(
                        total > 1 ? '照片预览  $cur / $total' : '照片预览',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // ── 页码指示器（多图时才显示）───────────────────
          Obx(() {
            if (controller.imagePaths.length <= 1) {
              return const SizedBox.shrink();
            }
            return Positioned(
              bottom: safeBottom + 118,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.imagePaths.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentIndex.value == i ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentIndex.value == i
                          ? AppColors.accent
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            );
          }),

          // ── 底部操作栏 ───────────────────────────────────
          Positioned(
            bottom: safeBottom + 28,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '确认病历照片清晰完整，再进行识别',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // 重拍
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.retake,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '重拍',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // 一键识别
                    Expanded(
                      flex: 2,
                      child: Obx(() {
                        final recognizing = controller.isRecognizing.value;
                        return GestureDetector(
                          onTap: recognizing
                              ? null
                              : controller.startRecognition,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 52,
                            decoration: BoxDecoration(
                              color: recognizing
                                  ? AppColors.accent.withValues(alpha: 0.6)
                                  : AppColors.accent,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: recognizing
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(
                                          alpha: 0.45,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: recognizing
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Obx(() {
                                      final count =
                                          controller.imagePaths.length;
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.auto_awesome_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            count > 1
                                                ? '一键识别（$count张）'
                                                : '一键识别',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ── 识别中全屏遮罩 ───────────────────────────────
          Obx(() {
            if (!controller.isRecognizing.value) return const SizedBox.shrink();
            return Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.82),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'AI 正在识别病历...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '正在提取医院、科室、诊断、医嘱等信息',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
