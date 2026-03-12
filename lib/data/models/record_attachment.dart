import 'package:flutter/material.dart';

enum AttachmentType {
  medicalPhoto,   // 病例照片
  reportPhoto,    // 检查单照片
  pdf,            // PDF 文件
  other,          // 其他
}

class RecordAttachment {
  final String id;
  final String path;   // 本地文件路径或 URI
  final String name;
  final AttachmentType type;
  final DateTime addedAt;

  const RecordAttachment({
    required this.id,
    required this.path,
    required this.name,
    required this.type,
    required this.addedAt,
  });

  bool get isImage =>
      type == AttachmentType.medicalPhoto || type == AttachmentType.reportPhoto;

  bool get isPdf => type == AttachmentType.pdf;

  IconData get icon {
    switch (type) {
      case AttachmentType.medicalPhoto:
        return Icons.article_rounded;
      case AttachmentType.reportPhoto:
        return Icons.biotech_rounded;
      case AttachmentType.pdf:
        return Icons.picture_as_pdf_rounded;
      case AttachmentType.other:
        return Icons.attach_file_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case AttachmentType.medicalPhoto:
        return const Color(0xFF2DBD6E);
      case AttachmentType.reportPhoto:
        return const Color(0xFF32ADE6);
      case AttachmentType.pdf:
        return const Color(0xFFFF6B6B);
      case AttachmentType.other:
        return const Color(0xFF8A8A8F);
    }
  }

  String get typeLabel {
    switch (type) {
      case AttachmentType.medicalPhoto:
        return '病例';
      case AttachmentType.reportPhoto:
        return '检查单';
      case AttachmentType.pdf:
        return 'PDF';
      case AttachmentType.other:
        return '附件';
    }
  }

  /// 从本地图片路径推断类型
  static AttachmentType typeFromPath(String path, {AttachmentType defaultType = AttachmentType.medicalPhoto}) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.pdf')) return AttachmentType.pdf;
    return defaultType;
  }
}
