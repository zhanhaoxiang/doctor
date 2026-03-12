import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.baseUrl;
    httpClient.timeout = AppConstants.connectTimeout;
    httpClient.addRequestModifier<dynamic>((request) {
      // 在这里添加公共请求头，例如 Token
      // request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }
}
