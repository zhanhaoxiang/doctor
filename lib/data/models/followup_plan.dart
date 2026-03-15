class FollowupPlan {
  const FollowupPlan({
    required this.id,
    required this.hospital,
    required this.department,
    required this.scheduledAt,
    this.note,
    this.memberId,
    this.memberName,
    this.isDefaultMember = false,
  });

  final String id;
  final String hospital;
  final String department;
  final DateTime scheduledAt;
  final String? note;
  final String? memberId;
  final String? memberName;
  final bool isDefaultMember;

  String get dateText {
    final y = scheduledAt.year;
    final mon = scheduledAt.month.toString().padLeft(2, '0');
    final day = scheduledAt.day.toString().padLeft(2, '0');
    return '$y-$mon-$day';
  }

  String get timeText {
    final h = scheduledAt.hour.toString().padLeft(2, '0');
    final m = scheduledAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
