class AppReminder {
  const AppReminder({
    required this.id,
    required this.title,
    required this.body,
    required this.remindAt,
    required this.type,
    this.memberId,
    this.memberName,
    this.recordId,
  });

  final String id;
  final String title;
  final String body;
  final DateTime remindAt;
  final String type;
  final String? memberId;
  final String? memberName;
  // 关联病历（复诊提醒时有值）
  final String? recordId;

  bool get isFollowup => type == 'followup';

  String get dateText {
    final y = remindAt.year;
    final mo = remindAt.month.toString().padLeft(2, '0');
    final d = remindAt.day.toString().padLeft(2, '0');
    return '$y-$mo-$d';
  }

  String get timeText {
    final h = remindAt.hour.toString().padLeft(2, '0');
    final m = remindAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
