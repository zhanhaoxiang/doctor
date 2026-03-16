import 'dart:io';

import 'package:doctor/logger.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// 本地 OCR 服务，使用 Google ML Kit Text Recognition 从图片中提取文字
///
/// 支持多张图片批量处理，降低 AI 接口的 token 消耗
class OCRService {
  OCRService._();

  // 使用中文识别器
  static TextRecognizer? _chineseRecognizer;

  // 使用拉丁文（英文）识别器作为备份
  static TextRecognizer? _latinRecognizer;

  /// 初始化识别器
  /// 确保在使用前调用此方法，特别是在 iOS 上
  static Future<void> initialize() async {
    try {
      _chineseRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);
      _latinRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      logger.i('[OCR] Recognizers initialized successfully');
    } catch (e) {
      logger.i('[OCR] Error initializing recognizers: $e');
      rethrow;
    }
  }

  /// 从多张图片中提取文字
  /// 返回 List(String)，对应每张图片的识别结果
  /// 如果某张图片识别失败，对应位置返回空字符串
  static Future<List<String>> extractText(List<String> imagePaths) async {
    // 确保识别器已初始化
    if (_chineseRecognizer == null || _latinRecognizer == null) {
      await initialize();
    }

    final results = <String>[];

    for (final path in imagePaths) {
      try {
        final file = File(path);
        if (!file.existsSync()) {
          logger.i('[OCR] File not found: $path');
          results.add('');
          continue;
        }

        final inputImage = InputImage.fromFilePath(path);

        // 先用中文识别器识别
        String text = '';
        try {
          final chineseText = await _chineseRecognizer!.processImage(inputImage);
          text = chineseText.text.trim();
          if (text.isNotEmpty) {
            logger.i('[OCR] ✓ Chinese recognition: ${text.length} chars from $path');
          }
        } catch (e) {
          logger.i('[OCR] Chinese recognition error: $e');
        }

        // 如果中文识别结果为空，尝试用拉丁文识别器
        if (text.isEmpty) {
          try {
            final inputImageLatin = InputImage.fromFilePath(path);
            final latinText = await _latinRecognizer!.processImage(inputImageLatin);
            text = latinText.text.trim();
            if (text.isNotEmpty) {
              logger.i('[OCR] ✓ Latin/English recognition: ${text.length} chars from $path');
            }
          } catch (e) {
            logger.i('[OCR] Latin recognition error: $e');
          }
        }

        if (text.isEmpty) {
          logger.i('[OCR] ⚠️  No text recognized from $path');
        }

        results.add(text);
      } catch (e) {
        logger.i('[OCR] Error processing $path: $e');
        results.add('');
      }
    }

    return results;
  }

  /// 合并多张图片的识别结果为单个文本
  /// 用于传送给 AI 接口处理
  static String mergeResults(List<String> ocrResults) {
    final validResults = ocrResults.where((r) => r.isNotEmpty).toList();
    if (validResults.isEmpty) return '';

    return validResults.asMap().entries.map((e) => '【图片 ${e.key + 1}】\n${e.value}').join('\n\n');
  }

  /// 释放资源
  static Future<void> dispose() async {
    try {
      await _chineseRecognizer?.close();
      await _latinRecognizer?.close();
      logger.i('[OCR] Recognizers closed');
    } catch (e) {
      logger.i('[OCR] Error closing recognizers: $e');
    }
  }
}
