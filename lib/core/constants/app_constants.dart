class AppConstants {
  AppConstants._();

  static const String appName = 'Doctor';

  // 通用 REST 基础 URL（GetConnect）
  static const String baseUrl = 'https://api.example.com';

  // 火山引擎 Ark API
  // ⚠️ 生产环境请将 API Key 移至安全配置（环境变量/后端代理）
  static const String arkApiKey = '6b561b29-fde8-4d2a-928c-068b2f016cd0';
  static const String arkEndpoint = 'https://ark.cn-beijing.volces.com/api/v3/chat/completions';
  static const String arkModel = 'doubao-seed-2-0-pro-260215';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 60);
}
