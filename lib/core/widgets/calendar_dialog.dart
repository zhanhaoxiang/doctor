import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 日期选择弹窗（中间弹出，使用 calendar_date_picker2）
/// 返回选中的日期，取消返回 null
Future<DateTime?> showCalendarDialog({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minimumDate,
  DateTime? maximumDate,
}) async {
  final initial = initialDate ?? DateTime.now();
  final minDate = minimumDate ?? DateTime(2000);
  final maxDate = maximumDate ?? DateTime.now();

  final results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      firstDate: minDate,
      lastDate: maxDate,
      currentDate: initial,
      selectedDayHighlightColor: AppColors.accent,
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      yearTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink1,
      ),
      controlsTextStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.ink1,
      ),
      dayTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.ink1,
      ),
      selectedDayTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      weekdayLabelTextStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.ink3,
      ),
      gapBetweenCalendarAndButtons: 0,
      cancelButtonTextStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.ink3,
      ),
      okButtonTextStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
      ),
    ),
    dialogSize: const Size(325, 400),
    value: [initial],
    borderRadius: BorderRadius.circular(16),
  );

  if (results != null && results.isNotEmpty) {
    return results.first;
  }
  return null;
}