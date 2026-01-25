class UserProfile {
  final String? erpnextPatientId;
  final String? patientName;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? mobileNo;
  final String? email;
  final String? sex;
  final String? dob;
  final int? age;
  final String? ageType;
  final String? bloodGroup;
  final String? status;
  final String? customer;
  final String? territory;
  final String? language;
  final String? createdAt;
  final String? updatedAt;
  final String? source;

  const UserProfile({
    this.erpnextPatientId,
    this.patientName,
    this.firstName,
    this.lastName,
    this.phone,
    this.mobileNo,
    this.email,
    this.sex,
    this.dob,
    this.age,
    this.ageType,
    this.bloodGroup,
    this.status,
    this.customer,
    this.territory,
    this.language,
    this.createdAt,
    this.updatedAt,
    this.source,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      erpnextPatientId: json['erpnext_patient_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      phone: json['phone']?.toString(),
      mobileNo: json['mobile_no']?.toString(),
      email: json['email']?.toString(),
      sex: json['sex']?.toString(),
      dob: json['dob']?.toString(),
      age: json['age'] is int ? json['age'] as int : int.tryParse('${json['age']}'),
      ageType: json['age_type']?.toString(),
      bloodGroup: json['blood_group']?.toString(),
      status: json['status']?.toString(),
      customer: json['customer']?.toString(),
      territory: json['territory']?.toString(),
      language: json['language']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      source: json['source']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'erpnext_patient_id': erpnextPatientId,
    'patient_name': patientName,
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
    'mobile_no': mobileNo,
    'email': email,
    'sex': sex,
    'dob': dob,
    'age': age,
    'age_type': ageType,
    'blood_group': bloodGroup,
    'status': status,
    'customer': customer,
    'territory': territory,
    'language': language,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'source': source,
  };

  UserProfile copyWith({
    String? patientName,
    String? firstName,
    String? lastName,
    String? phone,
    String? mobileNo,
    String? email,
    String? sex,
    String? dob,
    String? bloodGroup,
    String? territory,
    String? language,
  }) {
    return UserProfile(
      erpnextPatientId: erpnextPatientId,
      patientName: patientName ?? this.patientName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      sex: sex ?? this.sex,
      dob: dob ?? this.dob,
      age: age,
      ageType: ageType,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      status: status,
      customer: customer,
      territory: territory ?? this.territory,
      language: language ?? this.language,
      createdAt: createdAt,
      updatedAt: updatedAt,
      source: source,
    );
  }
}
