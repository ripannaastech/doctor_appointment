class Practitioner {
  final String? id;
  final String? fullName;
  final String? department;
  final String? doctorHall;
  final String? doctorRoom;
  final String? status;
  final String? mobile;
  final String? phoneResidence;
  final String? phoneOffice;
  final String? designation;

  // Charges & image
  final String? image;
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
    this.mobile,
    this.phoneResidence,
    this.phoneOffice,
    this.designation,
    this.image,
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

    return Practitioner(
      id: json['id']?.toString(),
      fullName: json['full_name']?.toString(),
      department: json['department']?.toString(),
      doctorHall: json['doctor_hall']?.toString(),
      doctorRoom: json['doctor_room']?.toString(),
      status: json['status']?.toString(),
      mobile: json['mobile']?.toString(),
      phoneResidence: json['phone_residence']?.toString(),
      phoneOffice: json['phone_office']?.toString(),
      designation: json['designation']?.toString(),
      image: json['image']?.toString(),

      opConsultingCharge: (json['op_consulting_charge'] is num)
          ? (json['op_consulting_charge'] as num).toDouble()
          : double.tryParse(json['op_consulting_charge']?.toString() ?? ''),
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
    "mobile": mobile,
    "phone_residence": phoneResidence,
    "phone_office": phoneOffice,
    "designation": designation,
    "image": image,
    "op_consulting_charge": opConsultingCharge,
    "op_consulting_charge_item": opConsultingChargeItem,
    "inpatient_visit_charge": inpatientVisitCharge,
    "inpatient_visit_charge_item": inpatientVisitChargeItem,
  };
}
