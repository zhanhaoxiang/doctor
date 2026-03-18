class NextAppointment {
  final DateTime dateTime;
  final String hospital;
  final String department;

  const NextAppointment({
    required this.dateTime,
    required this.hospital,
    required this.department,
  });

  String get formattedDate {
    final m = dateTime.month;
    final d = dateTime.day;
    final h = dateTime.hour.toString().padLeft(2, '0');
    final min = dateTime.minute.toString().padLeft(2, '0');
    return '$m月$d日 $h:$min';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NextAppointment &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          hospital == other.hospital &&
          department == other.department;

  @override
  int get hashCode => dateTime.hashCode ^ hospital.hashCode ^ department.hashCode;
}
