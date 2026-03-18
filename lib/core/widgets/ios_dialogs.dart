import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────
// iOS 风格文本输入弹窗
// 返回输入的字符串，取消返回 null
// ─────────────────────────────────────────────────────────────
Future<String?> showIosTextInputDialog({
  required String title,
  String? subtitle,
  String? initialValue,
  String placeholder = '请输入',
  String confirmText = '确定',
  String cancelText = '取消',
  TextInputType keyboardType = TextInputType.text,
  int? maxLength,
}) {
  return Get.dialog<String>(
    _IosTextInputDialog(
      title: title,
      subtitle: subtitle,
      initialValue: initialValue,
      placeholder: placeholder,
      confirmText: confirmText,
      cancelText: cancelText,
      keyboardType: keyboardType,
      maxLength: maxLength,
    ),
    barrierColor: Colors.black.withValues(alpha: 0.4),
    barrierDismissible: true,
  );
}

class _IosTextInputDialog extends StatefulWidget {
  const _IosTextInputDialog({
    required this.title,
    required this.placeholder,
    required this.confirmText,
    required this.cancelText,
    required this.keyboardType,
    this.subtitle,
    this.initialValue,
    this.maxLength,
  });

  final String title;
  final String? subtitle;
  final String? initialValue;
  final String placeholder;
  final String confirmText;
  final String cancelText;
  final TextInputType keyboardType;
  final int? maxLength;

  @override
  State<_IosTextInputDialog> createState() => _IosTextInputDialogState();
}

class _IosTextInputDialogState extends State<_IosTextInputDialog>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _textCtrl;
  late final AnimationController _anim;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.initialValue ?? '');
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _cancel() => Get.back<String>(result: null);

  void _confirm() {
    final text = _textCtrl.text.trim();
    Get.back<String>(result: text);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 270,
              decoration: BoxDecoration(
                // iOS 弹窗使用磨砂白背景
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─ 标题区 ─
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (widget.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
                      child: Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF8A8A8F),
                        ),
                      ),
                    ),
                  // ─ 输入框 ─
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _textCtrl,
                        autofocus: true,
                        keyboardType: widget.keyboardType,
                        maxLength: widget.maxLength,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1C1C1E),
                        ),
                        decoration: InputDecoration(
                          hintText: widget.placeholder,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFC7C7CC),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => _confirm(),
                      ),
                    ),
                  ),
                  // ─ 分割线 + 按钮 ─
                  Container(height: 0.5, color: const Color(0x4D000000)),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        // 取消
                        Expanded(
                          child: _ActionButton(
                            label: widget.cancelText,
                            color: const Color(0xFF007AFF),
                            fontWeight: FontWeight.w400,
                            onTap: _cancel,
                            leftRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                            ),
                          ),
                        ),
                        Container(width: 0.5, color: const Color(0x4D000000)),
                        // 确定
                        Expanded(
                          child: _ActionButton(
                            label: widget.confirmText,
                            color: const Color(0xFF007AFF),
                            fontWeight: FontWeight.w600,
                            onTap: _confirm,
                            leftRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.fontWeight,
    required this.onTap,
    required this.leftRadius,
  });

  final String label;
  final Color color;
  final FontWeight fontWeight;
  final VoidCallback onTap;
  final BorderRadius leftRadius;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _pressed
              ? const Color(0xFFE5E5EA)
              : Colors.transparent,
          borderRadius: widget.leftRadius,
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 17,
            color: widget.color,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// iOS 风格日期选择器（底部弹出）
// 返回选中的日期，取消返回 null
// ─────────────────────────────────────────────────────────────
Future<DateTime?> showIosDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minimumDate,
  DateTime? maximumDate,
}) {
  final initial = initialDate ?? DateTime.now();
  DateTime picked = initial;

  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (ctx) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖动把手
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D1D6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // 顶部操作栏
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(null),
                      child: const Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8A8A8F),
                        ),
                      ),
                    ),
                    const Text(
                      '选择日期',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(picked),
                      child: Text(
                        '完成',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 日历选择器
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initial,
                  minimumDate: minimumDate ?? DateTime(2000),
                  maximumDate: maximumDate ?? DateTime.now(),
                  onDateTimeChanged: (date) => picked = date,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
