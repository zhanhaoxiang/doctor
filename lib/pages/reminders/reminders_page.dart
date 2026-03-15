import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
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
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final remindAt = Rx<DateTime>(DateTime.now().add(const Duration(hours: 1)));
    final selectedMemberId = RxnString(
      controller.members.isNotEmpty ? controller.members.first.id : null,
    );

    await Get.dialog(
      AlertDialog(
        title: const Text('新建提醒'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: '标题'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bodyController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: '内容'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: selectedMemberId.value,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('不指定成员'),
                      ),
                      ...controller.members.map(
                        (member) => DropdownMenuItem<String?>(
                          value: member.id,
                          child: Text(member.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      selectedMemberId.value = value;
                      setState(() {});
                    },
                    decoration: const InputDecoration(labelText: '成员'),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('提醒时间'),
                    subtitle: Text(
                      '${remindAt.value.year}-${remindAt.value.month.toString().padLeft(2, '0')}-${remindAt.value.day.toString().padLeft(2, '0')} ${remindAt.value.hour.toString().padLeft(2, '0')}:${remindAt.value.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.calendar_month_rounded),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: remindAt.value,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        locale: const Locale('zh', 'CN'),
                      );
                      if (date == null || !context.mounted) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(remindAt.value),
                      );
                      if (time == null) return;
                      remindAt.value = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final body = bodyController.text.trim();
              if (title.isEmpty || body.isEmpty) {
                Get.snackbar(
                  '提示',
                  '请填写完整提醒内容',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              await controller.addReminder(
                title: title,
                body: body,
                remindAt: remindAt.value,
                memberId: selectedMemberId.value,
              );
              Get.back();
            },
            child: const Text('保存'),
          ),
        ],
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
