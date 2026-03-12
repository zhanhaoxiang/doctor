import 'package:get/get.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  // 使用 GetStorage 或 SharedPreferences 时在此封装
  // 示例：
  // final _box = GetStorage();
  // void write(String key, dynamic value) => _box.write(key, value);
  // T? read<T>(String key) => _box.read<T>(key);
  // void remove(String key) => _box.remove(key);
}
