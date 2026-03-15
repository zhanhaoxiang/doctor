import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/app_reminder.dart';
import '../../data/models/family_member.dart';
import '../../data/repositories/local_data_repository.dart';

class RemindersController extends GetxController {
  RemindersController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;
  final reminders = <AppReminder>[].obs;
  final members = <FamilyMember>[].obs;
  StreamSubscription<List<AppReminder>>? _remindersSubscription;
  StreamSubscription<List<FamilyMember>>? _membersSubscription;

  @override
  void onInit() {
    super.onInit();
    _remindersSubscription = _repository.watchReminders().listen(
      reminders.assignAll,
    );
    _membersSubscription = _repository.watchMembers().listen(members.assignAll);
  }

  List<AppReminder> remindersForDay(DateTime date) {
    return reminders.where((item) {
      final remindAt = item.remindAt;
      return remindAt.year == date.year &&
          remindAt.month == date.month &&
          remindAt.day == date.day;
    }).toList();
  }

  Future<void> addReminder({
    required String title,
    required String body,
    required DateTime remindAt,
    String? memberId,
  }) {
    return _repository.addReminder(
      title: title,
      body: body,
      remindAt: remindAt,
      memberId: memberId,
    );
  }

  @override
  void onClose() {
    _remindersSubscription?.cancel();
    _membersSubscription?.cancel();
    super.onClose();
  }
}
