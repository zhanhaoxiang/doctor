import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../data/models/recognition_result.dart';

/// 调用火山引擎豆包多模态 API，从病历图片中提取结构化信息
class ArkRecognitionService {
  ArkRecognitionService._();

  static final _dio = Dio(
    BaseOptions(
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Authorization': 'Bearer ${AppConstants.arkApiKey}',
        'Content-Type': 'application/json',
      },
    ),
  );

  static const _prompt = '''
你是一个医疗信息提取助手。请仔细阅读图片中的病历单、处方单或检查报告，
提取以下字段并以纯 JSON 格式返回，禁止输出 JSON 以外的任何内容（包括代码块标记）。
若某字段无法识别，对应值填空字符串或空数组。

{
  "hospital": "医院名称",
  "department": "科室名称",
  "doctor": "医生姓名",
  "visit_date": "就诊日期，格式 YYYY-MM-DD",
  "diagnosis": "诊断结论",
  "prescription": "医嘱或处方完整内容",
  "summary": "病历简要摘要，不超过 80 字",
  "medicines": ["药品名称数组"]
}''';

  /// 识别最多 3 张图片，返回合并的 [RecognitionResult]
  static Future<RecognitionResult> recognize(List<String> imagePaths) async {
    final content = <Map<String, dynamic>>[];

    // 最多取前 3 张，避免请求体过大
    for (final path in imagePaths.take(3)) {
      final bytes = await File(path).readAsBytes();
      final b64 = base64Encode(bytes);
      final ext = path.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
      content.add({
        'type': 'input_image',
        'image_url': 'data:image/$ext;base64,$b64',
      });
    }

    content.add({'type': 'input_text', 'text': _prompt});

    final requestBody = {
      'model': AppConstants.arkModel,
      'input': [
        {'role': 'user', 'content': content},
      ],
    };

    debugPrint('[Ark] Sending request, images=${imagePaths.length}');


    final response = await _dio.post<Map<String, dynamic>>(
      AppConstants.arkEndpoint,
      data: requestBody,
    );

    debugPrint('[Ark] Response status=${response.statusCode}');

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('API 请求失败 [${response.statusCode}]');
    }

    final rawText = _extractText(response.data!);
    debugPrint('[Ark] Raw text: $rawText');
    return RecognitionResult.fromAiText(rawText);
  }

  /// 从响应体中提取模型输出的文本内容
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
        final content = (choices[0] as Map?)?['message']?['content'];
        if (content is String) return content;
      }
    } catch (e) {
      debugPrint('[Ark] Parse response error: $e');
    }
    return '';
  }
}


