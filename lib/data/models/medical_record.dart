import 'record_attachment.dart';

class RecordTag {
  final String label;
  final int? bgColorValue;
  final int? textColorValue;

  const RecordTag(this.label, {this.bgColorValue, this.textColorValue});
}

class MedicalRecord {
  final String id;
  final String hospitalName;
  final DateTime visitDate;
  final String aiSummary;
  final List<RecordTag> tags;
  final String? familyMemberId;
  final String? department;
  final String? doctorName;
  final String? complaint;
  final String? diagnosis;
  final String doctorOrder;
  final String source;
  final List<RecordAttachment> attachments;

  const MedicalRecord({
    required this.id,
    required this.hospitalName,
    required this.visitDate,
    required this.aiSummary,
    required this.tags,
    this.familyMemberId,
    this.department,
    this.doctorName,
    this.complaint,
    this.diagnosis,
    this.doctorOrder = '',
    this.source = '手动录入',
    this.attachments = const [],
  });

  String get monthGroupKey => '${visitDate.year} 年 ${visitDate.month} 月';

  String get formattedDate {
    final m = visitDate.month.toString().padLeft(2, '0');
    final d = visitDate.day.toString().padLeft(2, '0');
    final h = visitDate.hour.toString().padLeft(2, '0');
    final min = visitDate.minute.toString().padLeft(2, '0');
    return '$m-$d $h:$min';
  }
}
