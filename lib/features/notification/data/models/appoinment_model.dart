class AppointmentDetails {
  final String? appointmentId;
  final String? tokenNumber;
  final String? doctor;
  final String? date;
  final String? time;
  final String? status;
  final String? department;
  final String? location;
  final String? reason;

  AppointmentDetails({
    this.appointmentId,
    this.tokenNumber,
    this.doctor,
    this.date,
    this.time,
    this.status,
    this.department,
    this.location,
    this.reason,
  });

  factory AppointmentDetails.fromAppointmentConfirmedData(Map<String, dynamic> data) {
    return AppointmentDetails(
      appointmentId: data['appointment_id']?.toString(),
      tokenNumber: data['token_number']?.toString(),
      doctor: data['doctor']?.toString(),
      date: data['date']?.toString(),
      time: data['time']?.toString(),
      status: data['status']?.toString(),
      department: data['department']?.toString(),
    );
  }
}
