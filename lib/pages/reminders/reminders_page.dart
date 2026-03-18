import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/app_reminder.dart';
import '../../data/models/family_member.dart';
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
              final now = DateTime.now();
              final today = controller.remindersForDay(now);
              final upcoming = controller.reminders
                  .where(
                    (r) =>
                        r.remindAt.isAfter(DateTime(now.year, now.month, now.day + 1)) &&
                        r.remindAt.isBefore(now.add(const Duration(days: 30))),
                  )
                  .toList();
              final history = controller.reminders
                  .where((r) => r.remindAt.isBefore(DateTime(now.year, now.month, now.day)))
                  .toList()
                  .reversed
                  .toList();

              final hasAny = today.isNotEmpty || upcoming.isNotEmpty || history.isNotEmpty;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  if (!hasAny)
                    const SliverPadding(
                      padding: EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: _EmptyCard(label: '暂无提醒，点击右上角添加'),
                      ),
                    ),
                  if (today.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(title: '今天', count: today.length),
                      ),
                    ),
                    _ReminderList(
                      items: today,
                      onEdit: (item) => _showEditDialog(context, item),
                      onDelete: (item) => _confirmAndDelete(context, item),
                    ),
                  ],
                  if (upcoming.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(title: '即将到来', count: upcoming.length),
                      ),
                    ),
                    _ReminderList(
                      items: upcoming,
                      onEdit: (item) => _showEditDialog(context, item),
                      onDelete: (item) => _confirmAndDelete(context, item),
                    ),
                  ],
                  if (history.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(title: '历史记录', count: history.length),
                      ),
                    ),
                    _ReminderList(
                      items: history,
                      dimmed: true,
                      onEdit: (item) => _showEditDialog(context, item),
                      onDelete: (item) => _confirmAndDelete(context, item),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
      builder: (ctx) => _ReminderFormSheet(
        members: controller.members.toList(),
        hospitalHistory: controller.hospitalHistory.toList(),
        onSave: (title, body, remindAt, memberId) async {
          await controller.addReminder(
            title: title,
            body: body,
            remindAt: remindAt,
            memberId: memberId,
            type: 'followup',
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, AppReminder item) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ReminderFormSheet(
        members: controller.members.toList(),
        hospitalHistory: controller.hospitalHistory.toList(),
        initialReminder: item,
        onSave: (title, body, remindAt, memberId) async {
          await controller.updateReminder(
            item.id,
            title: title,
            body: body,
            remindAt: remindAt,
            memberId: memberId,
          );
        },
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context, AppReminder item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('删除提醒', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('确定要删除「${item.title}」？', style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消', style: TextStyle(color: AppColors.ink3)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('删除', style: TextStyle(color: Color(0xFFFF3B30))),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteReminder(item.id);
      AppToast.show('已删除');
    }
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
            onTap: Get.back,
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 20,
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
              fontSize: 14,
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
  const _ReminderList({
    required this.items,
    this.dimmed = false,
    required this.onEdit,
    required this.onDelete,
  });

  final List<AppReminder> items;
  final bool dimmed;
  final void Function(AppReminder) onEdit;
  final void Function(AppReminder) onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ReminderCard(
              item: items[index],
              dimmed: dimmed,
              onEdit: () => onEdit(items[index]),
              onDelete: () => onDelete(items[index]),
            ),
          ),
          childCount: items.length,
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.item,
    this.dimmed = false,
    required this.onEdit,
    required this.onDelete,
  });

  final AppReminder item;
  final bool dimmed;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cardColor = dimmed ? const Color(0xFFF9F9F9) : Colors.white;
    final titleColor = dimmed ? AppColors.ink3 : AppColors.ink1;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            // 类型图标
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.isFollowup ? AppColors.accentLight : const Color(0xFFF0F0F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.isFollowup ? Icons.event_available_rounded : Icons.notifications_outlined,
                size: 18,
                color: item.isFollowup ? AppColors.accent : AppColors.ink3,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (item.body.isNotEmpty && item.body != '下次复诊提醒') ...[
                    const SizedBox(height: 2),
                    Text(
                      item.body,
                      style: const TextStyle(fontSize: 14, color: AppColors.ink3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 11,
                        color: dimmed ? AppColors.ink3.withValues(alpha: 0.5) : AppColors.ink3,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.dateText,
                        style: TextStyle(
                          fontSize: 14,
                          color: dimmed ? AppColors.ink3.withValues(alpha: 0.5) : AppColors.ink3,
                        ),
                      ),
                      if (item.memberName != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.memberName!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.ink3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // 右侧：复诊标签 + 操作菜单
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.isFollowup)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '复诊',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 4),
                PopupMenuButton<_ReminderAction>(
                  onSelected: (action) {
                    if (action == _ReminderAction.edit) {
                      onEdit();
                    } else {
                      onDelete();
                    }
                  },
                  offset: const Offset(0, 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 6,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: dimmed ? AppColors.bg : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      size: 16,
                      color: AppColors.ink3,
                    ),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _ReminderAction.edit,
                      height: 44,
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Icon(Icons.edit_rounded, size: 14, color: AppColors.accent),
                          ),
                          const SizedBox(width: 10),
                          const Text('编辑', style: TextStyle(fontSize: 14, color: AppColors.ink1)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _ReminderAction.delete,
                      height: 44,
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEEEE),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Icon(Icons.delete_outline_rounded, size: 14, color: Color(0xFFFF3B30)),
                          ),
                          const SizedBox(width: 10),
                          const Text('删除', style: TextStyle(fontSize: 14, color: Color(0xFFFF3B30))),
                        ],
                      ),
                    ),
                  ],
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
        style: const TextStyle(fontSize: 15, color: AppColors.ink3),
      ),
    );
  }
}

enum _ReminderAction { edit, delete }

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
// iOS 风格新建/编辑提醒底部面板
// ─────────────────────────────────────────────────────────────
typedef _SaveCallback =
    Future<void> Function(
      String title,
      String body,
      DateTime remindAt,
      String? memberId,
    );

class _ReminderFormSheet extends StatefulWidget {
  const _ReminderFormSheet({
    required this.members,
    required this.hospitalHistory,
    required this.onSave,
    this.initialReminder,
  });

  final List<FamilyMember> members;
  final List<String> hospitalHistory;
  final _SaveCallback onSave;
  final AppReminder? initialReminder;

  @override
  State<_ReminderFormSheet> createState() => _ReminderFormSheetState();
}

class _ReminderFormSheetState extends State<_ReminderFormSheet> {
  final _hospitalCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _hospitalFocus = FocusNode();
  late DateTime _remindAt;
  String? _selectedMemberId;
  bool _saving = false;

  List<String> get _filteredSuggestions {
    final q = _hospitalCtrl.text.trim().toLowerCase();
    final hist = widget.hospitalHistory;
    if (q.isEmpty) return hist.take(6).toList();
    return hist.where((h) => h.toLowerCase().contains(q)).take(6).toList();
  }

  @override
  void initState() {
    super.initState();
    _hospitalFocus.addListener(() => setState(() {}));
    if (widget.initialReminder != null) {
      // 编辑模式：预填现有数据
      final r = widget.initialReminder!;
      _hospitalCtrl.text = r.title;
      _bodyCtrl.text = (r.body == '下次复诊提醒') ? '' : r.body;
      _remindAt = r.remindAt;
      _selectedMemberId = r.memberId;
    } else {
      // 新建模式：默认明天上午9点
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      _remindAt = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
      if (widget.members.isNotEmpty) {
        _selectedMemberId = widget.members.first.id;
      }
    }
  }

  @override
  void dispose() {
    _hospitalCtrl.dispose();
    _bodyCtrl.dispose();
    _hospitalFocus.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final y = dt.year;
    final mo = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y年$mo月$d日';
  }

  String get _selectedMemberName {
    if (_selectedMemberId == null) return '不指定';
    final match = widget.members.where((m) => m.id == _selectedMemberId).toList();
    return match.isNotEmpty ? match.first.name : '不指定';
  }

  Future<void> _pickMember() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MemberPickerSheet(
        members: widget.members,
        selectedId: _selectedMemberId,
        onSelect: (id) {
          setState(() => _selectedMemberId = id);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  Future<void> _save() async {
    final hospital = _hospitalCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (hospital.isEmpty) {
      AppToast.show('请填写就诊医院');
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.onSave(hospital, body, _remindAt, _selectedMemberId);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      AppToast.error('保存失败：$error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final suggestions = _filteredSuggestions;
    final showSuggestions = _hospitalFocus.hasFocus && suggestions.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(maxHeight: screenHeight * 0.92),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖动条
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
            // 顶部导航栏
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      '取消',
                      style: TextStyle(fontSize: 16, color: Color(0xFF8A8A8F)),
                    ),
                  ),
                  Text(
                    widget.initialReminder != null ? '编辑提醒' : '新建提醒',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            // 可滚动表单主体
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 16),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    children: [
                      // ── 就诊日期（内联日历，最重要）────────────────────────
                      _FormCard(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9F0A),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  '就诊日期',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1C1C1E),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _formatDate(_remindAt),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF3B30).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '必填',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFFF3B30),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                              calendarType: CalendarDatePicker2Type.single,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                              currentDate: _remindAt,
                              selectedDayHighlightColor: AppColors.accent,
                              centerAlignModePicker: true,
                              customModePickerIcon: const SizedBox(),
                              controlsTextStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                              ),
                              dayTextStyle: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1C1C1E),
                              ),
                              selectedDayTextStyle: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              todayTextStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                              weekdayLabelTextStyle: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A8A8F),
                              ),
                              yearTextStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                              ),
                              disabledDayTextStyle: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFC7C7CC),
                              ),
                            ),
                            value: [_remindAt],
                            onValueChanged: (dates) {
                              if (dates.isNotEmpty) {
                                final d = dates.first;
                                setState(() => _remindAt = DateTime(d.year, d.month, d.day, 9, 0));
                              }
                            },
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // ── 医院 + 备注 ──────────────────────────────────────
                      _FormCard(
                        children: [
                          // 医院输入框
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '医院',
                                        style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8F)),
                                      ),
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(fontSize: 14, color: Color(0xFFFF3B30)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _hospitalCtrl,
                                    focusNode: _hospitalFocus,
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
                                    onChanged: (_) => setState(() {}),
                                    decoration: const InputDecoration(
                                      hintText: '请输入就诊医院',
                                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFFC7C7CC)),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                if (_hospitalCtrl.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => setState(() => _hospitalCtrl.clear()),
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 16,
                                      color: Color(0xFFC7C7CC),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // 历史下拉建议
                          if (showSuggestions) ...[
                            Container(
                              height: 0.5,
                              color: const Color(0x1A000000),
                              margin: const EdgeInsets.only(left: 14),
                            ),
                            ...suggestions.map(
                              (h) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _hospitalCtrl.text = h;
                                  _hospitalFocus.unfocus();
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.history_rounded,
                                        size: 14,
                                        color: AppColors.ink3,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        h,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.ink2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const _Divider(),
                          // 备注
                          _FormField(
                            label: '备注',
                            controller: _bodyCtrl,
                            hint: '可选，备注信息',
                            minLines: 2,
                            maxLines: 4,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // ── 提醒成员 ──────────────────────────────────────────
                      if (widget.members.isNotEmpty)
                        _FormCard(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _pickMember,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 13,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '提醒成员',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1C1C1E),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _selectedMemberName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF8A8A8F),
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
                          ],
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── iOS 风格成员选择器 ────────────────────────────────────────────────────────

class _MemberPickerSheet extends StatelessWidget {
  const _MemberPickerSheet({
    required this.members,
    required this.selectedId,
    required this.onSelect,
  });

  final List<FamilyMember> members;
  final String? selectedId;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖动条
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              '选择成员',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 12),
            // 成员列表
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 不指定选项
                  _MemberTile(
                    name: '不指定',
                    avatarColor: const Color(0xFFD1D1D6),
                    initial: '—',
                    isSelected: selectedId == null,
                    onTap: () => onSelect(null),
                  ),
                  ...List.generate(members.length, (i) {
                    final m = members[i];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 0.5,
                          color: const Color(0x1A000000),
                          margin: const EdgeInsets.only(left: 60),
                        ),
                        _MemberTile(
                          name: m.name,
                          avatarColor: m.accentColor,
                          initial: m.name.isNotEmpty ? m.name[0] : '?',
                          isSelected: selectedId == m.id,
                          onTap: () => onSelect(m.id),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.name,
    required this.avatarColor,
    required this.initial,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final Color avatarColor;
  final String initial;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: initial == '—' ? const Color(0xFF8A8A8F) : avatarColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: 20,
                color: AppColors.accent,
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
    return Container(
      height: 0.5,
      color: const Color(0x1A000000),
      margin: const EdgeInsets.only(left: 78),
    );
  }
}
