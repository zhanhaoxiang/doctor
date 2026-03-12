import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'scan_camera_controller.dart';

class CameraPage extends GetView<ScanCameraController> {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // ── 背景渐变 ─────────────────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
                ),
              ),
            ),
          ),

          // ── 主体内容 ─────────────────────────────────────
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  // 顶部栏
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        _CircleBtn(
                          onTap: Get.back,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              '拍摄病历',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 文档扫描示意图
                  const _DocumentIllustration(),

                  const SizedBox(height: 32),

                  // 使用提示
                  const _TipsList(),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // ── 底部扫描按钮 ─────────────────────────────────
          Positioned(
            bottom: safeBottom + 32,
            left: 24,
            right: 24,
            child: Obx(() => _ScanButton(
                  isScanning: controller.isScanning.value,
                  onTap: controller.startScan,
                )),
          ),
        ],
      ),
    );
  }
}

// ── 文档扫描示意图 ─────────────────────────────────────────
class _DocumentIllustration extends StatelessWidget {
  const _DocumentIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: CustomPaint(
          painter: _IllustrationPainter(),
        ),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // 外圆光晕
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.18),
          AppColors.accent.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width / 2));
    canvas.drawCircle(Offset(cx, cy), size.width / 2, glowPaint);

    // 文档矩形（白色卡片）
    const docW = 100.0;
    const docH = 140.0;
    final docRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: docW, height: docH),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      docRect,
      Paint()..color = const Color(0xFF2A2A2A),
    );
    canvas.drawRRect(
      docRect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 文档内模拟文字行
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final y = cy - 40 + i * 14.0;
      final w = (i == 2 || i == 5) ? 48.0 : 72.0;
      canvas.drawLine(Offset(cx - w / 2, y), Offset(cx + w / 2, y), linePaint);
    }

    // 绿色扫描角标
    final cornerPaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const pad = 8.0;
    const cLen = 18.0;
    final l = cx - docW / 2 - pad;
    final t = cy - docH / 2 - pad;
    final r = cx + docW / 2 + pad;
    final b = cy + docH / 2 + pad;

    // 左上
    canvas.drawLine(Offset(l, t + cLen), Offset(l, t), cornerPaint);
    canvas.drawLine(Offset(l, t), Offset(l + cLen, t), cornerPaint);
    // 右上
    canvas.drawLine(Offset(r - cLen, t), Offset(r, t), cornerPaint);
    canvas.drawLine(Offset(r, t), Offset(r, t + cLen), cornerPaint);
    // 左下
    canvas.drawLine(Offset(l, b - cLen), Offset(l, b), cornerPaint);
    canvas.drawLine(Offset(l, b), Offset(l + cLen, b), cornerPaint);
    // 右下
    canvas.drawLine(Offset(r - cLen, b), Offset(r, b), cornerPaint);
    canvas.drawLine(Offset(r, b), Offset(r, b - cLen), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── 使用提示列表 ──────────────────────────────────────────
class _TipsList extends StatelessWidget {
  const _TipsList();

  static const _tips = [
    (Icons.wb_sunny_outlined, '光线充足', '保持环境明亮，避免强反光或阴影'),
    (Icons.crop_free_rounded, '完整对齐', '将病历单完整放入扫描框内'),
    (Icons.straighten_rounded, '保持平整', '确保纸张平铺，减少折痕与弯曲'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: _tips
            .map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _TipRow(icon: tip.$1, title: tip.$2, desc: tip.$3),
                ))
            .toList(),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.accent, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── 扫描按钮 ──────────────────────────────────────────────
class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.isScanning, required this.onTap});
  final bool isScanning;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isScanning ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: isScanning
              ? AppColors.accent.withValues(alpha: 0.6)
              : AppColors.accent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isScanning
              ? null
              : [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isScanning
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.document_scanner_outlined, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      '开始扫描病历',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── 圆形按钮 ──────────────────────────────────────────────
class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Center(child: child),
      ),
    );
  }
}
