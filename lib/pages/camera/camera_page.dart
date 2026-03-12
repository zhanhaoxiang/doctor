import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'scan_camera_controller.dart';

class CameraPage extends GetView<ScanCameraController> {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 相机预览 ─────────────────────────────────────
          Obx(() {
            if (controller.hasError.value) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      '无法访问相机',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '请在系统设置中开启相机权限',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
                    ),
                  ],
                ),
              );
            }
            if (!controller.isInitialized.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return CameraPreview(controller.cameraCtrl);
          }),

          // ── 引导遮罩（带镂空方框）────────────────────────
          Obx(() {
            if (!controller.isInitialized.value || controller.hasError.value) {
              return const SizedBox.shrink();
            }
            return LayoutBuilder(builder: (context, constraints) {
              return _GuideOverlay(size: constraints.biggest);
            });
          }),

          // ── 顶部操作栏 ───────────────────────────────────
          Positioned(
            top: safeTop + 10,
            left: 16,
            right: 16,
            child: _TopBar(controller: controller),
          ),

          // ── 底部拍摄按钮 ─────────────────────────────────
          Positioned(
            bottom: safeBottom + 36,
            left: 0,
            right: 0,
            child: _CaptureButton(controller: controller),
          ),

          // ── 处理中遮罩 ───────────────────────────────────
          Obx(() {
            if (!controller.isProcessing.value) return const SizedBox.shrink();
            return _ProcessingOverlay(controller: controller);
          }),
        ],
      ),
    );
  }
}

// ── 引导覆盖层 ──────────────────────────────────────────────
class _GuideOverlay extends StatelessWidget {
  const _GuideOverlay({required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    final guideW = size.width * 0.84;
    final guideH = guideW * 1.42; // 接近 A4 纸比例
    final guideL = (size.width - guideW) / 2;
    final guideT = (size.height - guideH) / 2 - 24;
    final guideRect = Rect.fromLTWH(guideL, guideT, guideW, guideH);

    return Stack(
      children: [
        CustomPaint(
          size: size,
          painter: _OverlayPainter(guideRect: guideRect),
        ),
        // 上方引导文字
        Positioned(
          left: 0,
          right: 0,
          top: guideT - 70,
          child: Column(
            children: [
              const Text(
                '请将病历单对准框内',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '保持稳定，确保光线充足',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 13,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
        // 下方提示文字
        Positioned(
          left: 0,
          right: 0,
          top: guideT + guideH + 16,
          child: Text(
            '系统将自动识别并裁剪纸质区域',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 12,
              shadows: const [Shadow(color: Colors.black45, blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }
}

// ── 顶部栏 ────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});
  final ScanCameraController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleBtn(
          onTap: Get.back,
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        ),
        const Expanded(
          child: Center(
            child: Text(
              '拍摄病历',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
          ),
        ),
        Obx(() => _CircleBtn(
              onTap: controller.toggleFlash,
              filled: controller.isFlashOn.value,
              child: Icon(
                controller.isFlashOn.value ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                color: Colors.white,
                size: 20,
              ),
            )),
      ],
    );
  }
}

// ── 拍摄按钮 ──────────────────────────────────────────────
class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.controller});
  final ScanCameraController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: controller.capturePhoto,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// ── 处理中遮罩 ────────────────────────────────────────────
class _ProcessingOverlay extends StatelessWidget {
  const _ProcessingOverlay({required this.controller});
  final ScanCameraController controller;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.78),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                color: AppColors.accent,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  ScanCameraController.processingSteps[controller.processingStep.value],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            const SizedBox(height: 8),
            Text(
              '请稍候...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 圆形按钮 ──────────────────────────────────────────────
class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.onTap, required this.child, this.filled = false});
  final VoidCallback onTap;
  final Widget child;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: filled ? Colors.amber : Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ── 自定义遮罩绘制器 ──────────────────────────────────────
class _OverlayPainter extends CustomPainter {
  const _OverlayPainter({required this.guideRect});
  final Rect guideRect;

  @override
  void paint(Canvas canvas, Size size) {
    // 半透明遮罩（镂空矩形）
    final maskPaint = Paint()..color = Colors.black.withValues(alpha: 0.52);
    final maskPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(guideRect, const Radius.circular(10)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(maskPath, maskPaint);

    // 镂空边框细线
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(guideRect, const Radius.circular(10)),
      borderPaint,
    );

    // 绿色角标
    final cornerPaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const cLen = 26.0;
    final l = guideRect.left;
    final t = guideRect.top;
    final r = guideRect.right;
    final b = guideRect.bottom;

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
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) =>
      oldDelegate.guideRect != guideRect;
}
