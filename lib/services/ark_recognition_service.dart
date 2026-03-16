import 'package:dio/dio.dart';
import 'package:doctor/logger.dart';

import '../core/constants/app_constants.dart';
import '../data/models/recognition_result.dart';
import 'ocr_service.dart';

/// 调用火山引擎豆包多模态 API，从病历图片中提取结构化信息
///
/// 流程：
/// 1. 使用 OCRService 从图片中本地提取文字（节省 token）
/// 2. 将提取的文字发送给 AI 进行结构化处理
class ArkRecognitionService {
  ArkRecognitionService._();

  static final _dio = Dio(
    BaseOptions(
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {'Authorization': 'Bearer ${AppConstants.arkApiKey}', 'Content-Type': 'application/json'},
      validateStatus: (_) => true,
    ),
  );

  static const _systemPrompt = '''你是一个医疗信息提取助手。请根据提供的病历文本信息，
提取以下字段并以 JSON 格式返回。若某字段无法识别，对应值填空字符串或空数组。''';

  static const _userPrompt = '''请从以下病历文本中提取结构化信息：

{ocrText}

返回格式必须严格符合以下 JSON 结构：
{{
  "name": "姓名",
  "hospital": "医院名称",
  "department": "科室名称",
  "doctor": "医生姓名",
  "visit_date": "就诊日期，格式 YYYY-MM-DD",
  "diagnosis": "诊断结论",
  "prescription": "医嘱或处方完整内容",
  "summary": "病历简要摘要，不超过 80 字",
  "medicines": ["药品名称数组"]
}}''';

  /// 识别最多 3 张图片，返回合并的 [RecognitionResult]
  ///
  /// 优化流程：
  /// 1. 先用 OCRService 本地提取文字（无 token 消耗）
  /// 2. 再发送文字给 AI（大幅节省 token）
  static Future<RecognitionResult> recognize(List<String> imagePaths) async {
    logger.i('[Ark] Starting recognition, images=${imagePaths.length}');

    // 第一步：本地 OCR 提取文字
    logger.i('[Ark] Extracting text using OCR...');
    final ocrResults = await OCRService.extractText(imagePaths.take(3).toList());
    final mergedText = OCRService.mergeResults(ocrResults);

    if (mergedText.isEmpty) {
      logger.i('[Ark] OCR extraction failed, no text found');
      throw Exception('图片文字提取失败，请确保图片清晰可读');
    }

    logger.i('[Ark] OCR extracted ${mergedText.length} chars');
    logger.i('[Ark] OCR text $mergedText');

    // 第二步：发送提取的文字给 AI 进行结构化处理
    final userPrompt = _userPrompt.replaceAll('{ocrText}', mergedText);

    final requestBody = {
      'model': AppConstants.arkModel,
      'messages': [
        {'role': 'system', 'content': _systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'response_format': {
        'type': 'json_schema', // 指定使用 JSON Schema 约束
        'json_schema': {
          'name': 'medical_record', // 自定义名称
          'strict': true, // 严格模式，不符合 schema 会报错
          'schema': {
            'type': 'object',
            'properties': {
              'name': {'type': 'string'}, // 患者姓名
              'hospital': {'type': 'string'}, // 医院名称
              'department': {'type': 'string'}, // 科室名称
              'doctor': {'type': 'string'}, // 医生姓名
              'visit_date': {'type': 'string', 'description': '格式YYYY-MM-DD'}, // 就诊日期（YYYY-MM-DD）
              'diagnosis': {'type': 'string'}, // 诊断结论
              'prescription': {'type': 'string'}, // 医嘱/处方
              'summary': {'type': 'string', 'description': '摘要，最多80字'}, // 摘要（最多80字）
              'medicines': {
                'type': 'array',
                'items': {'type': 'string'},
              }, // 药品数组
            },
            'required': [
              // 必返回字段（即使值为空）
              'hospital',
              'department',
              'doctor',
              'visit_date',
              'diagnosis',
              'prescription',
              'summary',
              'medicines',
            ],
            'additionalProperties': false, // 禁止返回 schema 外的字段
          },
        },
      },
    };

    logger.i('[Ark] Sending structured request to API');

    final response = await _dio.post<Map<String, dynamic>>(AppConstants.arkEndpoint, data: requestBody);

    logger.i('[Ark] Response status=${response.statusCode}');
    logger.i('[Ark] Response data=${response.data}');

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('API 请求失败 [${response.statusCode}]');
    }

    final rawText = _extractText(response.data!);
    logger.i('[Ark] Raw text received, length=${rawText.length}');
    return RecognitionResult.fromAiText(rawText);
  }

  /// 从响应体中提取模型输出的文本内容
  /// 支持多种火山引擎 API 响应格式
  static String _extractText(Map<String, dynamic> json) {
    try {
      // 格式 1: Responses API ── output[].content[].text
      final output = json['output'];
      if (output is List && output.isNotEmpty) {
        final first = output[0];
        if (first is Map) {
          final content = first['content'];
          if (content is List && content.isNotEmpty) {
            final text = (content[0] as Map?)?['text'];
            if (text is String) return text;
          }
          final contentStr = first['content'];
          if (contentStr is String) return contentStr;
        }
      }

      // 格式 2: Chat Completions ── choices[].message.content
      final choices = json['choices'];
      if (choices is List && choices.isNotEmpty) {
        final message = (choices[0] as Map?)?['message'];
        if (message is Map) {
          final content = message['content'];
          if (content is String) return content;
        }
      }
    } catch (e) {
      logger.i('[Ark] Parse response error: $e');
    }
    return '';
  }
}
