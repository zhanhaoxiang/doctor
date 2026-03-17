import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../theme/app_colors.dart';

/// 全局 Toast 工具
class AppToast {
  AppToast._();

  static const _duration = Duration(milliseconds: 2000);

  /// 普通提示
  static void show(String message) {
    showToastWidget(
      _ToastWidget(message: message, type: _ToastType.info),
      duration: _duration,
      position: ToastPosition.top,
    );
  }

  /// 成功提示（绿色）
  static void success(String message) {
    showToastWidget(
      _ToastWidget(message: message, type: _ToastType.success),
      duration: _duration,
      position: ToastPosition.top,
    );
  }

  /// 错误提示（红色）
  static void error(String message) {
    showToastWidget(
      _ToastWidget(message: message, type: _ToastType.error),
      duration: _duration,
      position: ToastPosition.top,
    );
  }
}

enum _ToastType { info, success, error

class _ToastWidget extends StatelessWidget {
  const _ToastWidget({required this.message, required this.type});

  final String message;
  final _ToastType type;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final IconData icon;

    switch (type) {
      case _ToastType.success:
        bg = AppColors.accent;
        fg = Colors.white;
        icon = Icons.check_circle_rounded;
      case _ToastType.error:
        bg = const Color(0xFFE53935);
        fg = Colors.white;
        icon = Icons.error_rounded;
      case _ToastType.info:
        bg = const Color(0xFF323232);
        fg = Colors.white;
        icon = Icons.info_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: bg.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: fg,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
