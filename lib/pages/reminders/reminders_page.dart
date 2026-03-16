import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/calendar_dialog.dart';
import '../../data/models/app_reminder.dart';
import 'reminders_controller.dart';

class RemindersPage extends GetView<RemindersController> {
  const RemindersPage({super.key});

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
            child: _TopBar(onAdd: () => _showCreateDialog(context)),
          ),
          Expanded(
            child: Obx(() {
              final today = controller.remindersForDay(DateTime.now());
              final tomorrow = controller.remindersForDay(
                DateTime.now().add(const Duration(days: 1)),
              );
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _SectionHeader(title: '今天', count: today.length),
                    ),
                  ),
                  _ReminderList(items: today),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _SectionHeader(
                        title: '明天',
                        count: tomorrow.length,
                      ),
                    ),
                  ),
                  _ReminderList(items: tomorrow),
                  if (today.isEmpty && tomorrow.isEmpty)
                    const SliverPadding(
                      padding: EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: _EmptyCard(label: '暂无提醒，点击右上角添加'),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CreateReminderSheet(
        members: controller.members.toList(),
        onSave: (title, body, remindAt, memberId) async {
          await controller.addReminder(
            title: title,
            body: body,
            remindAt: remindAt,
            memberId: memberId,
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          _IconBtn(
            onTap: () =>
                Get.snackbar('菜单', '打开菜单', snackPosition: SnackPosition.BOTTOM),
            child: const Icon(
              Icons.menu_rounded,
              size: 16,
              color: AppColors.ink2,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '提醒/医嘱',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink1,
                ),
              ),
            ),
          ),
          _IconBtn(
            onTap: onAdd,
            child: const Icon(
              Icons.add_rounded,
              size: 18,
              color: AppColors.ink2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.ink1,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderList extends StatelessWidget {
  const _ReminderList({required this.items});

  final List<AppReminder> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ReminderCard(item: items[index]),
          ),
          childCount: items.length,
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.item});

  final AppReminder item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.ink1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.body,
              style: const TextStyle(fontSize: 12, color: AppColors.ink2),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 12,
                  color: AppColors.ink3,
                ),
                const SizedBox(width: 4),
                Text(
                  item.timeText,
                  style: const TextStyle(fontSize: 11, color: AppColors.ink3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, color: AppColors.ink3),
      ),
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

// ─────────────────────────────────────────────────────────────
// iOS 风格新建提醒底部面板
// ─────────────────────────────────────────────────────────────
typedef _SaveCallback =
    Future<void> Function(
      String title,
      String body,
      DateTime remindAt,
      String? memberId,
    );

class _CreateReminderSheet extends StatefulWidget {
  const _CreateReminderSheet({
    required this.members,
    required this.onSave,
  });

  final List<dynamic> members;
  final _SaveCallback onSave;

  @override
  State<_CreateReminderSheet> createState() => _CreateReminderSheetState();
}

class _CreateReminderSheetState extends State<_CreateReminderSheet> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  late DateTime _remindAt;
  String? _selectedMemberId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _remindAt = DateTime.now().add(const Duration(hours: 1));
    if (widget.members.isNotEmpty) {
      _selectedMemberId = (widget.members.first as dynamic).id as String?;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year;
    final mo = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$y-$mo-$d  $h:$mi';
  }

  Future<void> _pickDateTime() async {
    // 先选日期（使用日历弹窗）
    final date = await showCalendarDialog(
      context: context,
      initialDate: _remindAt,
      minimumDate: DateTime.now().subtract(const Duration(days: 1)),
      maximumDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    // 再选时间（CupertinoDatePicker time 模式）
    DateTime picked = DateTime(
      date.year,
      date.month,
      date.day,
      _remindAt.hour,
      _remindAt.minute,
    );

    final confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8A8A8F),
                        ),
                      ),
                    ),
                    const Text(
                      '选择时间',
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
                      onPressed: () => Navigator.of(ctx).pop(true),
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
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: picked,
                  onDateTimeChanged: (dt) {
                    picked = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      dt.hour,
                      dt.minute,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _remindAt = picked);
    }
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty) {
      Get.snackbar('提示', '请填写提醒标题', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (body.isEmpty) {
      Get.snackbar('提示', '请填写提醒内容', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.onSave(title, body, _remindAt, _selectedMemberId);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      Get.snackbar('保存失败', '$error', snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖动条 + 顶部栏
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8A8A8F),
                      ),
                    ),
                  ),
                  const Text(
                    '新建提醒',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const CupertinoActivityIndicator()
                        : Text(
                            '保存',
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
            // 表单区
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // 标题 & 内容
                  _FormCard(
                    children: [
                      _FormField(
                        label: '标题',
                        controller: _titleCtrl,
                        hint: '提醒标题',
                      ),
                      const _Divider(),
                      _FormField(
                        label: '内容',
                        controller: _bodyCtrl,
                        hint: '提醒内容',
                        minLines: 2,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 时间 & 成员
                  _FormCard(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _pickDateTime,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 64,
                                child: Text(
                                  '提醒时间',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF8A8A8F),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _formatDateTime(_remindAt),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1C1C1E),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: Color(0xFFC7C7CC),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.members.isNotEmpty) ...[
                        const _Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 64,
                                child: Text(
                                  '成员',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF8A8A8F),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String?>(
                                    value: _selectedMemberId,
                                    alignment: Alignment.centerRight,
                                    icon: const Icon(
                                      Icons.expand_more_rounded,
                                      size: 18,
                                      color: Color(0xFFC7C7CC),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1C1C1E),
                                    ),
                                    items: [
                                      const DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text(
                                          '不指定成员',
                                          style: TextStyle(
                                            color: Color(0xFF8A8A8F),
                                          ),
                                        ),
                                      ),
                                      ...widget.members.map(
                                        (m) => DropdownMenuItem<String?>(
                                          value: (m as dynamic).id as String?,
                                          child: Text(
                                            (m as dynamic).name as String,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (v) =>
                                        setState(() => _selectedMemberId = v),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              width: 64,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8A8A8F),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: minLines,
              maxLines: maxLines,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFC7C7CC),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 0.5, color: const Color(0x1A000000), margin: const EdgeInsets.only(left: 78));
  }
}
