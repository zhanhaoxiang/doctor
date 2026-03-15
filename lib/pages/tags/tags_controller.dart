import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/medical_record.dart';
import '../../data/repositories/local_data_repository.dart';

class TagsController extends GetxController {
  TagsController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;
  final tags = <RecordTag>[].obs;
  StreamSubscription<List<RecordTag>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.watchTags().listen(tags.assignAll);
  }

  Future<void> addTag(String label) => _repository.addTag(label);

  Future<void> renameTag(String oldLabel, String newLabel) =>
      _repository.renameTag(oldLabel, newLabel);

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
