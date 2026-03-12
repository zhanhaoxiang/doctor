import 'package:get/get.dart';

abstract class BaseRepository {
  /// 统一处理接口响应
  T handleResponse<T>(Response response, T Function(dynamic) fromJson) {
    if (response.isOk && response.body != null) {
      return fromJson(response.body);
    }
    throw Exception('Request failed: ${response.statusCode} ${response.statusText}');
  }
}
