import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/recognition_result.dart';
import '../../data/models/record_attachment.dart';

class EditController extends GetxController {
  // ── 表单字段控制器 ──────────────────────────────────────
  final hospitalCtrl = TextEditingController();
  final departmentCtrl = TextEditingController();
  final doctorCtrl = TextEditingController();
  final visitDateCtrl = TextEditingController();
  final diagnosisCtrl = TextEditingController();
  final prescriptionCtrl = TextEditingController();
  final summaryCtrl = TextEditingController();

  // ── 响应式状态 ──────────────────────────────────────────
  final attachments = <RecordAttachment>[].obs;
  final selectedMember = '妈妈'.obs;
  final isSaving = false.obs;

  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _fillFromRecognition(
        args['result'] as RecognitionResult?,
        args['imagePaths'] as List<String>?,
      );
    }
  }

  void _fillFromRecognition(
      RecognitionResult? result, List<String>? imagePaths) {
    if (result != null && !result.isEmpty) {
      hospitalCtrl.text = result.hospital;
      departmentCtrl.text = result.department;
      doctorCtrl.text = result.doctor;
      visitDateCtrl.text = result.visitDate;
      diagnosisCtrl.text = result.diagnosis;
      prescriptionCtrl.text = result.prescription;
      summaryCtrl.text = result.summary;
    }

    if (imagePaths != null) {
      final now = DateTime.now();
      attachments.addAll(
        imagePaths.asMap().entries.map((e) {
          final type = RecordAttachment.typeFromPath(e.value,
              defaultType: AttachmentType.medicalPhoto);
          return RecordAttachment(
            id: 'img_${now.millisecondsSinceEpoch}_${e.key}',
            path: e.value,
            name: type == AttachmentType.pdf
                ? '文档 ${e.key + 1}.pdf'
                : '病历照片 ${e.key + 1}',
            type: type,
            addedAt: now,
          );
        }),
      );
    }
  }

  // ── 添加附件：相机扫描 ──────────────────────────────────
  Future<void> addPhotoFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 92,
    );
    if (image == null) return;
    _addImageAttachment(image.path, AttachmentType.medicalPhoto);
  }

  // ── 添加附件：相册 ──────────────────────────────────────
  Future<void> addPhotoFromGallery() async {
    final images = await _picker.pickMultiImage(imageQuality: 92);
    for (final img in images) {
      _addImageAttachment(img.path, AttachmentType.reportPhoto);
    }
  }

  // ── 删除附件 ────────────────────────────────────────────
  void removeAttachment(String id) {
    attachments.removeWhere((a) => a.id == id);
  }

  void _addImageAttachment(String path, AttachmentType type) {
    final now = DateTime.now();
    attachments.add(RecordAttachment(
      id: 'att_${now.millisecondsSinceEpoch}',
      path: path,
      name: type == AttachmentType.reportPhoto ? '检查单照片' : '病历照片',
      type: type,
      addedAt: now,
    ));
  }

  // ── 历史记录（去重后的医院 / 科室列表）───────────────────
  // 实际项目中应从本地数据库查询；这里用固定示例数据
  static const historyHospitals = [
    '北京协和医院', '北京儿童医院', '301 医院', '北京大学人民医院',
    '北京朝阳医院', '社区卫生服务中心',
  ];

  static const historyDepartments = [
    '呼吸内科', '儿科', '骨科', '消化内科', '心内科',
    '皮肤科', '眼科', '耳鼻喉科', '神经内科', '急诊科',
  ];

  // ── 选择就诊日期 ────────────────────────────────────────
  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime initial;
    try {
      initial = visitDateCtrl.text.isNotEmpty
          ? DateTime.parse(visitDateCtrl.text)
          : now;
    } catch (_) {
      initial = now;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: now,
      locale: const Locale('zh', 'CN'),
    );
    if (picked != null) {
      visitDateCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void save() {
    Get.snackbar(
      '已保存',
      '病历已录入，附件 ${attachments.length} 个',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2DBD6E),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    hospitalCtrl.dispose();
    departmentCtrl.dispose();
    doctorCtrl.dispose();
    visitDateCtrl.dispose();
    diagnosisCtrl.dispose();
    prescriptionCtrl.dispose();
    summaryCtrl.dispose();
    super.onClose();
  }

  bool isImageFile(String path) =>
      !path.toLowerCase().endsWith('.pdf');
}

