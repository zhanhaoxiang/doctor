import 'package:doctor/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_page.dart';
import '../../core/widgets/ios_dialogs.dart';
import '../../data/models/medical_record.dart';
import 'tags_controller.dart';

class TagsPage extends GetView<TagsController> {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: '标签管理',
      trailing: GestureDetector(
        onTap: () => _showTagDialog(context),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Icon(Icons.add_rounded, size: 18, color: AppColors.ink2),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Obx(() {
              if (controller.tags.isEmpty) {
                return const _TagContainer(
                  child: Text(
                    '暂无标签，点击右上角添加',
                    style: TextStyle(fontSize: 15, color: AppColors.ink3),
                  ),
                );
              }
              return _TagContainer(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.tags
                      .map(
                        (tag) => _TagChip(
                          tag: tag,
                          onTap: () => _showTagDialog(context, tag: tag),
                        ),
                      )
                      .toList(),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Future<void> _showTagDialog(BuildContext context, {RecordTag? tag}) async {
    final label = await showIosTextInputDialog(
      title: tag == null ? '新增标签' : '修改标签',
      initialValue: tag?.label,
      placeholder: '例如：#呼吸内科',
      confirmText: '保存',
      maxLength: 20,
    );

    if (label == null || label.isEmpty) {
      if (label != null) {
        AppToast.show('标签不能为空');
      }
      return;
    }

    try {
      if (tag == null) {
        await controller.addTag(label);
      } else {
        await controller.renameTag(tag.label, label);
      }
    } catch (error) {
      AppToast.error('保存失败：$error');
    }
  }
}

class _TagContainer extends StatelessWidget {
  const _TagContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag, required this.onTap});

  final RecordTag tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasCustomStyle =
        tag.bgColorValue != null && tag.textColorValue != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: hasCustomStyle ? Color(tag.bgColorValue!) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
        ),
        child: Text(
          tag.label,
          style: TextStyle(
            fontSize: 14,
            color: hasCustomStyle ? Color(tag.textColorValue!) : AppColors.ink2,
          ),
        ),
      ),
    );
  }
}
