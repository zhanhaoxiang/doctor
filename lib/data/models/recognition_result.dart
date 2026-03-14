import 'dart:convert';
import 'package:flutter/foundation.dart';

/// 火山引擎 AI 识别后从病历图片中提取的结构化信息
class RecognitionResult {
  final String hospital;
  final String department;
  final String doctor;
  final String visitDate;
  final String diagnosis;
  final String prescription;
  final String summary;
  final List<String> medicines;

  const RecognitionResult({
    required this.hospital,
    required this.department,
    required this.doctor,
    required this.visitDate,
    required this.diagnosis,
    required this.prescription,
    required this.summary,
    required this.medicines,
  });

  const RecognitionResult.empty()
      : hospital = '',
        department = '',
        doctor = '',
        visitDate = '',
        diagnosis = '',
        prescription = '',
        summary = '',
        medicines = const [];

  /// 从 AI 返回的文本解析 JSON
  /// 
  /// 支持多种格式：
  /// 1. 纯 JSON 对象（response_format: json_object 模式）
  /// 2. JSON 包裹在 markdown 代码块中
  /// 3. JSON 之前或之后有其他文本
  factory RecognitionResult.fromAiText(String rawText) {
    try {
      if (rawText.isEmpty) {
        debugPrint('RecognitionResult parse error: empty text');
        return const RecognitionResult.empty();
      }

      var text = rawText.trim();

      // 去除 markdown 代码块包裹（```json ... ```）
      text = text.replaceAll(RegExp(r'```(?:json)?\s*'), '').replaceAll('```', '').trim();

      // 提取第一个 { ... } 块
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start == -1 || end == -1 || start >= end) {
        throw const FormatException('no valid JSON object found');
      }

      final jsonStr = text.substring(start, end + 1);
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;

      return RecognitionResult(
        hospital: _parseString(map, 'hospital'),
        department: _parseString(map, 'department'),
        doctor: _parseString(map, 'doctor'),
        visitDate: _parseString(map, 'visit_date'),
        diagnosis: _parseString(map, 'diagnosis'),
        prescription: _parseString(map, 'prescription'),
        summary: _parseString(map, 'summary'),
        medicines: _parseStringArray(map, 'medicines'),
      );
    } catch (e) {
      debugPrint('RecognitionResult parse error: $e\nRaw: $rawText');
      return const RecognitionResult.empty();
    }
  }

  /// 安全解析字符串字段
  static String _parseString(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is String) return value.trim();
    if (value == null) return '';
    return value.toString().trim();
  }

  /// 安全解析字符串数组字段
  static List<String> _parseStringArray(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null) return [];
    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  bool get isEmpty =>
      hospital.isEmpty &&
      department.isEmpty &&
      diagnosis.isEmpty &&
      prescription.isEmpty;

  @override
  String toString() => 'RecognitionResult('
      'hospital=$hospital, '
      'department=$department, '
      'doctor=$doctor, '
      'visitDate=$visitDate, '
      'diagnosis=$diagnosis, '
      'prescription=$prescription, '
      'summary=$summary, '
      'medicines=${medicines.length} items)';
}
