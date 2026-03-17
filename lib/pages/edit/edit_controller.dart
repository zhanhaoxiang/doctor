import 'package:doctor/core/utils/app_toast.dart';
import 'package:doctor/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/widgets/calendar_dialog.dart';
import '../../data/models/family_member.dart';
import '../../data/models/recognition_result.dart';
import '../../data/models/record_attachment.dart';
import '../../data/repositories/local_data_repository.dart';

class EditController extends GetxController {
  EditController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;

  final hospitalCtrl = TextEditingController();
  final departmentCtrl = TextEditingController();
  final doctorCtrl = TextEditingController();
  final visitDateCtrl = TextEditingController();
  final diagnosisCtrl = TextEditingController();
  final prescriptionCtrl = TextEditingController();
  final summaryCtrl = TextEditingController();

  final attachments = <RecordAttachment>[].obs;
  final members = <FamilyMember>[].obs;
  final historyHospitals = <String>[].obs;
  final historyDepartments = <String>[].obs;
  final selectedMemberId = RxnString();
  final followupDate = Rxn<DateTime>();
  final isSaving = false.obs;

  final _picker = ImagePicker();
  String? _editingRecordId;

  String get selectedMemberLabel {
    final memberId = selectedMemberId.value;
    for (final member in members) {
      if (member.id == memberId) return member.name;
    }
    return '请选择成员';
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _fillFromRecognition(args['result'] as RecognitionResult?, args['imagePaths'] as List<String>?);
    } else if (args is String) {
      _editingRecordId = args;
      _loadExistingRecord(args);
    }
  }

  Future<void> _loadInitialData() async {
    members.assignAll(await _repository.loadMembers());
    historyHospitals.assignAll(await _repository.loadHospitalHistory());
    historyDepartments.assignAll(await _repository.loadDepartmentHistory());
    if (selectedMemberId.value == null && members.isNotEmpty) {
      selectedMemberId.value = members.first.id;
    }
  }

  Future<void> _loadExistingRecord(String id) async {
    final record = await _repository.getMedicalRecord(id);
    if (record == null) return;
    hospitalCtrl.text = record.hospitalName;
    departmentCtrl.text = record.department ?? '';
    doctorCtrl.text = record.doctorName ?? '';
    visitDateCtrl.text =
        '${record.visitDate.year}-${record.visitDate.month.toString().padLeft(2, '0')}-${record.visitDate.day.toString().padLeft(2, '0')}';
    diagnosisCtrl.text = record.diagnosis ?? '';
    prescriptionCtrl.text = record.doctorOrder;
    summaryCtrl.text = record.aiSummary;
    attachments.assignAll(record.attachments);
    selectedMemberId.value = record.familyMemberId;
    // 加载已有的复诊提醒日期
    followupDate.value = await _repository.getFollowupReminderDate(id);
  }

  void _fillFromRecognition(RecognitionResult? result, List<String>? imagePaths) {
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
        imagePaths.asMap().entries.map((entry) {
          final type = RecordAttachment.typeFromPath(entry.value, defaultType: AttachmentType.medicalPhoto);
          return RecordAttachment(
            id: 'img_${now.millisecondsSinceEpoch}_${entry.key}',
            path: entry.value,
            name: type == AttachmentType.pdf ? '文档 ${entry.key + 1}.pdf' : '病历照片 ${entry.key + 1}',
            type: type,
            addedAt: now,
          );
        }),
      );
    }
  }

  Future<void> addPhotoFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 92);
    if (image == null) return;
    _addImageAttachment(image.path, AttachmentType.medicalPhoto);
  }

  Future<void> addPhotoFromGallery() async {
    final images = await _picker.pickMultiImage(imageQuality: 92);
    for (final image in images) {
      _addImageAttachment(image.path, AttachmentType.reportPhoto);
    }
  }

  void removeAttachment(String id) {
    attachments.removeWhere((attachment) => attachment.id == id);
  }

  void _addImageAttachment(String path, AttachmentType type) {
    final now = DateTime.now();
    attachments.add(
      RecordAttachment(
        id: 'att_${now.microsecondsSinceEpoch}',
        path: path,
        name: type == AttachmentType.reportPhoto ? '检查单照片' : '病历照片',
        type: type,
        addedAt: now,
      ),
    );
  }

  Future<void> pickFollowupDate(BuildContext context) async {
    final picked = await showCalendarDialog(
      context: context,
      initialDate: followupDate.value,
      minimumDate: DateTime.now(),
    );
    if (picked != null) followupDate.value = picked;
  }

  void clearFollowupDate() => followupDate.value = null;

  String get followupDateLabel {
    final d = followupDate.value;
    if (d == null) return '不设置';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? initial;
    try {
      initial = visitDateCtrl.text.isNotEmpty ? DateTime.parse(visitDateCtrl.text) : null;
    } catch (_) {
      initial = null;
    }

    final picked = await showCalendarDialog(context: context, initialDate: initial);
    if (picked != null) {
      visitDateCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> save() async {
    if (isSaving.value) return;
    if (hospitalCtrl.text.trim().isEmpty || visitDateCtrl.text.trim().isEmpty) {
      AppToast.show('请至少填写医院和就诊日期');
      return;
    }

    final visitDate = DateTime.tryParse(visitDateCtrl.text.trim());
    if (visitDate == null) {
      AppToast.show('就诊日期格式不正确');
      return;
    }
    logger.i(
      'Saving record for memberId=${selectedMemberId.value}, hospital=${hospitalCtrl.text}, visitDate=${visitDateCtrl.text}, attachments=${attachments.length}',
    );

    isSaving.value = true;
    try {
      await _repository.saveMedicalRecord(
        recordId: _editingRecordId,
        hospitalName: hospitalCtrl.text,
        department: departmentCtrl.text,
        doctorName: doctorCtrl.text,
        visitDate: visitDate,
        diagnosis: diagnosisCtrl.text,
        summary: summaryCtrl.text,
        doctorOrder: prescriptionCtrl.text,
        memberId: selectedMemberId.value,
        attachments: attachments.toList(),
        followupDate: followupDate.value,
      );
      historyHospitals.assignAll(await _repository.loadHospitalHistory());
      historyDepartments.assignAll(await _repository.loadDepartmentHistory());
      AppToast.success('病历已写入本地数据库');
      logger.i('保存成功');
      Get.back();
    } catch (error) {
      logger.i('保存失败， $error');
      logger.e(error.toString(), error: error);
      AppToast.error('保存失败：$error');
    } finally {
      isSaving.value = false;
    }
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
}
