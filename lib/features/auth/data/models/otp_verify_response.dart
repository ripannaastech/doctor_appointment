import 'package:doctor_appointment/features/auth/data/models/patient_profile_response.dart';

class OtpVerifyRes {
  final bool success;
  final String message;
  final bool isNewPatient;

  final String? accessToken;
  final String? tokenType;
  final PatientProfile? patient;

  const OtpVerifyRes({
    required this.success,
    required this.message,
    required this.isNewPatient,
    this.accessToken,
    this.tokenType,
    this.patient,
  });

  factory OtpVerifyRes.fromJson(Map<String, dynamic> json) {
    return OtpVerifyRes(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      isNewPatient: json['is_new_patient'] == true,

      accessToken: json['access_token']?.toString(),
      tokenType: json['token_type']?.toString(),

      patient: json['patient'] is Map<String, dynamic>
          ? PatientProfile.fromJson(Map<String, dynamic>.from(json['patient']))
          : null,
    );
  }
}
