class DoctorSlot {
  final String time;        // "08:00:00"
  final String displayTime; // "08:00 AM"
  final bool available;
  final bool disabled;
  final String? reason;

  DoctorSlot({
    required this.time,
    required this.displayTime,
    required this.available,
    required this.disabled,
    this.reason,
  });

  factory DoctorSlot.fromJson(Map<String, dynamic> json) {
    return DoctorSlot(
      time: (json['time'] ?? '').toString(),
      displayTime: (json['display_time'] ?? '').toString(),
      available: json['available'] == true,
      disabled: json['disabled'] == true,
      reason: json['reason']?.toString(),
    );
  }
}
