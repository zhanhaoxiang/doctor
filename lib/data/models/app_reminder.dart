class AppReminder {
  const AppReminder({
    required this.id,
    required this.title,
    required this.body,
    required this.remindAt,
    required this.type,
    this.memberId,
    this.memberName,
  });

  final String id;
  final String title;
  final String body;
  final DateTime remindAt;
  final String type;
  final String? memberId;
  final String? memberName;

  String get timeText {
    final h = remindAt.hour.toString().padLeft(2, '0');
    final m = remindAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
