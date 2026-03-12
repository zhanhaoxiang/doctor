class RecordTag {
  final String label;
  // null 表示使用默认样式
  final int? bgColorValue;
  final int? textColorValue;

  const RecordTag(
    this.label, {
    this.bgColorValue,
    this.textColorValue,
  });
}

class MedicalRecord {
  final String id;
  final String hospitalName;
  final DateTime visitDate;
  final String aiSummary;
  final List<RecordTag> tags;
  /// null 表示属于全家人
  final String? familyMemberId;

  const MedicalRecord({
    required this.id,
    required this.hospitalName,
    required this.visitDate,
    required this.aiSummary,
    required this.tags,
    this.familyMemberId,
  });

  /// 用于分组的 key，格式：yyyy 年 M 月
  String get monthGroupKey =>
      '${visitDate.year} 年 ${visitDate.month} 月';

  /// 显示日期，格式：MM-dd HH:mm
  String get formattedDate {
    final m = visitDate.month.toString().padLeft(2, '0');
    final d = visitDate.day.toString().padLeft(2, '0');
    final h = visitDate.hour.toString().padLeft(2, '0');
    final min = visitDate.minute.toString().padLeft(2, '0');
    return '$m-$d $h:$min';
  }
}
