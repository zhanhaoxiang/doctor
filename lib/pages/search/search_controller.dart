import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/medical_record.dart';
import '../../data/repositories/local_data_repository.dart';

class RecordSearchController extends GetxController {
  RecordSearchController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;

  final results = <MedicalRecord>[].obs;
  final hospitals = <String>[].obs;
  final departments = <String>[].obs;
  final isLoading = false.obs;
  final query = ''.obs;

  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // 加载快速搜索建议
    _loadSuggestions();
    // 防抖搜索：400ms 内无变化才执行
    debounce(query, _performSearch, time: const Duration(milliseconds: 400));
    textController.addListener(() {
      query.value = textController.text;
    });
  }

  Future<void> _loadSuggestions() async {
    hospitals.assignAll(await _repository.loadHospitalHistory());
    departments.assignAll(await _repository.loadDepartmentHistory());
  }

  Future<void> _performSearch(String q) async {
    if (q.trim().isEmpty) {
      results.clear();
      return;
    }
    isLoading.value = true;
    try {
      final found = await _repository.searchMedicalRecords(q.trim());
      results.assignAll(found);
    } finally {
      isLoading.value = false;
    }
  }

  /// 点击快速搜索chip时调用
  void applyQuickFilter(String keyword) {
    textController.text = keyword;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: keyword.length),
    );
  }

  void clearQuery() {
    textController.clear();
    results.clear();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
