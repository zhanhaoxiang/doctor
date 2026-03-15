import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/family_member.dart';
import '../../data/models/medical_record.dart';
import '../../data/models/next_appointment.dart';
import '../../data/repositories/local_data_repository.dart';

class HomeController extends GetxController {
  HomeController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;
  final familyMembers = <FamilyMember>[].obs;
  final records = <MedicalRecord>[].obs;
  final nextAppointment = Rxn<NextAppointment>();
  final selectedMemberIndex = (-1).obs;

  StreamSubscription<List<FamilyMember>>? _membersSubscription;
  StreamSubscription<List<MedicalRecord>>? _recordsSubscription;
  StreamSubscription<NextAppointment?>? _appointmentSubscription;

  @override
  void onInit() {
    super.onInit();
    _membersSubscription = _repository.watchMembers().listen((items) {
      familyMembers.assignAll(items);
      if (selectedMemberIndex.value >= items.length) {
        selectedMemberIndex.value = -1;
      }
    });
    _recordsSubscription = _repository.watchMedicalRecords().listen(
      records.assignAll,
    );
    _appointmentSubscription = _repository.watchNextAppointment().listen(
      nextAppointment.call,
    );
  }

  List<MedicalRecord> get filteredRecords {
    final idx = selectedMemberIndex.value;
    if (idx < 0 || idx >= familyMembers.length) return records;
    final memberId = familyMembers[idx].id;
    return records
        .where((record) => record.familyMemberId == memberId)
        .toList();
  }

  List<({String label, List<MedicalRecord> records})> get groupedRecords {
    final sorted = [...filteredRecords]
      ..sort((a, b) => b.visitDate.compareTo(a.visitDate));
    final map = <String, List<MedicalRecord>>{};
    for (final record in sorted) {
      map.putIfAbsent(record.monthGroupKey, () => []).add(record);
    }
    return map.entries
        .map((entry) => (label: entry.key, records: entry.value))
        .toList();
  }

  FamilyMember? memberById(String? id) {
    if (id == null) return null;
    for (final member in familyMembers) {
      if (member.id == id) return member;
    }
    return null;
  }

  Future<void> selectMember(int index) async {
    selectedMemberIndex.value = selectedMemberIndex.value == index ? -1 : index;
  }

  @override
  void onClose() {
    _membersSubscription?.cancel();
    _recordsSubscription?.cancel();
    _appointmentSubscription?.cancel();
    super.onClose();
  }
}
