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

  factory RecognitionResult.fromAiText(String rawText) {
    try {
      var text = rawText.trim();
      // 去除 markdown 代码块包裹
      text = text.replaceAll(RegExp(r'```\w*\s*'), '').replaceAll('```', '').trim();
      // 提取第一个 { ... } 块
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start == -1 || end == -1) throw const FormatException('no JSON object');
      final jsonStr = text.substring(start, end + 1);

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return RecognitionResult(
        hospital: (map['hospital'] as String?) ?? '',
        department: (map['department'] as String?) ?? '',
        doctor: (map['doctor'] as String?) ?? '',
        visitDate: (map['visit_date'] as String?) ?? '',
        diagnosis: (map['diagnosis'] as String?) ?? '',
        prescription: (map['prescription'] as String?) ?? '',
        summary: (map['summary'] as String?) ?? '',
        medicines: ((map['medicines'] as List<dynamic>?) ?? [])
            .map((e) => e.toString())
            .toList(),
      );
    } catch (e) {
      debugPrint('RecognitionResult parse error: $e\nRaw: $rawText');
      return const RecognitionResult.empty();
    }
  }

  bool get isEmpty =>
      hospital.isEmpty &&
      department.isEmpty &&
      diagnosis.isEmpty &&
      prescription.isEmpty;
}
