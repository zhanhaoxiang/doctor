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
}
