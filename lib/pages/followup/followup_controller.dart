import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/followup_plan.dart';
import '../../data/repositories/local_data_repository.dart';

class FollowupController extends GetxController {
  FollowupController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;
  final items = <FollowupPlan>[].obs;
  StreamSubscription<List<FollowupPlan>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.watchFollowups().listen(items.assignAll);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
