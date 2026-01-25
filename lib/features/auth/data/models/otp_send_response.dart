class OtpSendRes {
  final String message;
  final String phone;
  final bool isExistingPatient;
  final int expiresInMinutes;
  final bool smsSent;
  final String? otp; // ⚠️ should be removed in production if backend returns it

  OtpSendRes({
    required this.message,
    required this.phone,
    required this.isExistingPatient,
    required this.expiresInMinutes,
    required this.smsSent,
    this.otp,
  });

  factory OtpSendRes.fromJson(Map<String, dynamic> j) => OtpSendRes(
    message: j['message']?.toString() ?? '',
    phone: j['phone']?.toString() ?? '',
    isExistingPatient: j['is_existing_patient'] == true,
    expiresInMinutes: (j['expires_in_minutes'] as num?)?.toInt() ?? 10,
    smsSent: j['sms_sent'] == true,
    otp: j['otp']?.toString(),
  );
}

