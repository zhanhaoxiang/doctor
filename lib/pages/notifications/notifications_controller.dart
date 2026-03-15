import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/app_notification.dart';
import '../../data/repositories/local_data_repository.dart';

class NotificationsController extends GetxController {
  NotificationsController() : _repository = Get.find<LocalDataRepository>();

  final LocalDataRepository _repository;
  final items = <AppNotification>[].obs;
  StreamSubscription<List<AppNotification>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.watchNotifications().listen(items.assignAll);
  }

  Future<void> clearAll() => _repository.clearNotifications();

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
