// ===============================
// appointment_models.dart
// ===============================

class AppointmentSummary {
  final String name; // OPD-00057
  final String patient;
  final String patientName;
  final String practitioner;
  final String practitionerName;
  final String department;
  final String appointmentDate; // "2026-01-29"
  final String appointmentTime; // "11:00:00"
  final int duration;
  final String status; // "Scheduled"
  final String? notes;
  final String appointmentType; // "Walk-In"
  final String billingItem; // "OPD Consultation"
  final int docStatus;

  AppointmentSummary({
    required this.name,
    required this.patient,
    required this.patientName,
    required this.practitioner,
    required this.practitionerName,
    required this.department,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.duration,
    required this.status,
    this.notes,
    required this.appointmentType,
    required this.billingItem,
    required this.docStatus, //   

  });


  factory AppointmentSummary.fromJson(Map<String, dynamic> json) {
    return AppointmentSummary(
      name: (json['name'] ?? '').toString(),
      patient: (json['patient'] ?? '').toString(),
      patientName: (json['patient_name'] ?? '').toString(),
      practitioner: (json['practitioner'] ?? '').toString(),
      practitionerName: (json['practitioner_name'] ?? '').toString(),
      department: (json['department'] ?? '').toString(),
      appointmentDate: (json['appointment_date'] ?? '').toString(),
      appointmentTime: (json['appointment_time'] ?? '').toString(),
      duration: _intOrZero(json['duration']),
      status: (json['status'] ?? '').toString(),
      notes: json['notes']?.toString(),
      appointmentType: (json['appointment_type'] ?? '').toString(),
      billingItem: (json['billing_item'] ?? '').toString(),
      docStatus: _intOrZero(json['docstatus']),
    );
  }

  static int _intOrZero(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}

class AppointmentCreatePayload {
  /// Adjust keys to match your backend exactly.
  /// Typical ERPNext booking needs: patient, practitioner, department, date, time, notes, type, etc.
  final String patient; // PID-00678
  final String practitioner; // "Dr Abdirahman" OR practitioner id depending on backend
  final String department; // "Cardiology"
  final String appointmentDate; // "2026-01-29"
  final String appointmentTime; // "11:00:00"
  final String appointmentType; // "Walk-In"
  final String? notes;

  AppointmentCreatePayload({
    required this.patient,
    required this.practitioner,
    required this.department,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "patient": patient,
      "practitioner": practitioner,
      "department": department,
      "appointment_date": appointmentDate,
      "appointment_time": appointmentTime,
      "appointment_type": appointmentType,
      "notes": notes,
    };
  }
}
