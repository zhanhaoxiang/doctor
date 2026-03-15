import 'package:get/get.dart';

import '../../data/models/medical_record.dart';
import '../../data/repositories/local_data_repository.dart';

class DetailController extends GetxController {
  DetailController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;
  final record = Rxn<MedicalRecord>();
  final memberName = ''.obs;

  String get recordId => record.value?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final id = switch (args) {
      String value => value,
      MedicalRecord value => value.id,
      _ => null,
    };
    if (id != null) {
      loadRecord(id);
    }
  }

  Future<void> loadRecord(String id) async {
    final loaded = await _repository.getMedicalRecord(id);
    record.value = loaded;
    memberName.value =
        await _repository.getMemberName(loaded?.familyMemberId) ?? '未指定成员';
  }
}
