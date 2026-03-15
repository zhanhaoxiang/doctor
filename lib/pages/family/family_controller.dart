import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/member_summary.dart';
import '../../data/repositories/local_data_repository.dart';

class FamilyController extends GetxController {
  FamilyController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;
  final members = <MemberSummary>[].obs;
  StreamSubscription<List<MemberSummary>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.watchMemberSummaries().listen(
      members.assignAll,
    );
  }

  Future<void> addMember(String name) => _repository.addMember(name);

  Future<void> renameMember(String id, String name) =>
      _repository.renameMember(id, name);

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
