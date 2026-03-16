import 'package:doctor/data/local/app_database.dart';
import 'package:doctor/data/repositories/local_data_repository.dart';
import 'package:doctor/services/locale_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('默认会创建“我”成员', () async {
    Get.testMode = true;
    Get.put(LocaleService());
    final repository = await LocalDataRepository(
      database: AppDatabase.forTesting(NativeDatabase.memory()),
    ).init();
    Get.put(repository);

    final members = await repository.loadMembers();

    expect(members, isNotEmpty);
    expect(members.first.name, '默认病历本');

    await repository.close();
    Get.reset();
  });
}
