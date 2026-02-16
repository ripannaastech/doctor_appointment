class Practitioner {
  final String? id;
  final String? fullName;
  final String? department;
  final String? doctorHall;
  final String? doctorRoom;
  final String? status;
  final String? gender;

  final String? mobile;
  final String? phoneResidence;
  final String? phoneOffice;

  final String? designation;
  final String? image;

  final String? degree;
  final String? specialization;
  final int? experienceYears;
  final String? bio;
  final String? education;
  final String? languages;
  final String? availableDays;

  final double? opConsultingCharge;
  final String? opConsultingChargeItem;

  final double? inpatientVisitCharge;
  final String? inpatientVisitChargeItem;

  Practitioner({
    this.id,
    this.fullName,
    this.department,
    this.doctorHall,
    this.doctorRoom,
    this.status,
    this.gender,
    this.mobile,
    this.phoneResidence,
    this.phoneOffice,
    this.designation,
    this.image,
    this.degree,
    this.specialization,
    this.experienceYears,
    this.bio,
    this.education,
    this.languages,
    this.availableDays,
    this.opConsultingCharge,
    this.opConsultingChargeItem,
    this.inpatientVisitCharge,
    this.inpatientVisitChargeItem,
  });

  factory Practitioner.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    return Practitioner(
      id: json['id']?.toString(),
      fullName: json['full_name']?.toString(),
      department: json['department']?.toString(),
      doctorHall: json['doctor_hall']?.toString(),
      doctorRoom: json['doctor_room']?.toString(),
      status: json['status']?.toString(),
      gender: json['gender']?.toString(),
      mobile: json['mobile']?.toString(),
      phoneResidence: json['phone_residence']?.toString(),
      phoneOffice: json['phone_office']?.toString(),
      designation: json['designation']?.toString(),
      image: json['image']?.toString(),
      degree: json['degree']?.toString(),
      specialization: json['specialization']?.toString(),
      experienceYears: parseInt(json['experience_years']),
      bio: json['bio']?.toString(),
      education: json['education']?.toString(),
      languages: json['languages']?.toString(),
      availableDays: json['available_days']?.toString(),
      opConsultingCharge: parseDouble(json['op_consulting_charge']),
      opConsultingChargeItem: json['op_consulting_charge_item']?.toString(),
      inpatientVisitCharge: parseDouble(json['inpatient_visit_charge']),
      inpatientVisitChargeItem:
      json['inpatient_visit_charge_item']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "department": department,
    "doctor_hall": doctorHall,
    "doctor_room": doctorRoom,
    "status": status,
    "gender": gender,
    "mobile": mobile,
    "phone_residence": phoneResidence,
    "phone_office": phoneOffice,
    "designation": designation,
    "image": image,
    "degree": degree,
    "specialization": specialization,
    "experience_years": experienceYears,
    "bio": bio,
    "education": education,
    "languages": languages,
    "available_days": availableDays,
    "op_consulting_charge": opConsultingCharge,
    "op_consulting_charge_item": opConsultingChargeItem,
    "inpatient_visit_charge": inpatientVisitCharge,
    "inpatient_visit_charge_item": inpatientVisitChargeItem,
  };
}
