class PatientProfile {
  final String? patientId;
  final String? patientName;
  final String? mobile;
  final String? email;
  final String? sex;
  final String? dob;

  const PatientProfile({
    this.patientId,
    this.patientName,
    this.mobile,
    this.email,
    this.sex,
    this.dob,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      patientId: json['patient_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      sex: json['sex']?.toString(),
      dob: json['dob']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    'patient_name': patientName,
    'mobile': mobile,
    'email': email,
    'sex': sex,
    'dob': dob,
  };
}
