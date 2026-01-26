class LabTestSummary {
  final String name;
  final String patient;
  final String patientName;
  final String? template;
  final String? labTestName;
  final String? practitioner;
  final String? practitionerName;
  final String? resultDate;
  final String? status;
  final String? department;
  final String? company;

  LabTestSummary({
    required this.name,
    required this.patient,
    required this.patientName,
    this.template,
    this.labTestName,
    this.practitioner,
    this.practitionerName,
    this.resultDate,
    this.status,
    this.department,
    this.company,
  });

  factory LabTestSummary.fromJson(Map<String, dynamic> json) {
    return LabTestSummary(
      name: (json['name'] ?? '').toString(),
      patient: (json['patient'] ?? '').toString(),
      patientName: (json['patient_name'] ?? '').toString(),
      template: json['template']?.toString(),
      labTestName: json['lab_test_name']?.toString(),
      practitioner: json['practitioner']?.toString(),
      practitionerName: json['practitioner_name']?.toString(),
      resultDate: json['result_date']?.toString(),
      status: json['status']?.toString(),
      department: json['department']?.toString(),
      company: json['company']?.toString(),
    );
  }
}

class NormalTestItem {
  final String name;
  final String? labTestName;
  final String? uom;
  final String? normalRange;
  final int? requireResultValue;

  // NOTE: ERPNext Lab Test may store result in fields like:
  // result_value / result / value (depends on customization)
  // so we keep it flexible:
  final String? resultValue;

  NormalTestItem({
    required this.name,
    this.labTestName,
    this.uom,
    this.normalRange,
    this.requireResultValue,
    this.resultValue,
  });

  factory NormalTestItem.fromJson(Map<String, dynamic> json) {
    String? rv;
    if (json['result_value'] != null) rv = json['result_value'].toString();
    if (rv == null && json['result'] != null) rv = json['result'].toString();
    if (rv == null && json['value'] != null) rv = json['value'].toString();

    return NormalTestItem(
      name: (json['name'] ?? '').toString(),
      labTestName: json['lab_test_name']?.toString(),
      uom: json['lab_test_uom']?.toString(),
      normalRange: json['normal_range']?.toString(),
      requireResultValue: _intOrNull(json['require_result_value']),
      resultValue: rv,
    );
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}

class LabTestDetail {
  final String name;
  final String? status;
  final String? patient;
  final String? patientName;
  final String? patientAge;
  final String? patientSex;
  final String? practitionerName;
  final String? department;
  final String? company;
  final String? resultDate;
  final List<NormalTestItem> normalItems;

  LabTestDetail({
    required this.name,
    this.status,
    this.patient,
    this.patientName,
    this.patientAge,
    this.patientSex,
    this.practitionerName,
    this.department,
    this.company,
    this.resultDate,
    required this.normalItems,
  });

  factory LabTestDetail.fromJson(Map<String, dynamic> json) {
    final itemsRaw = (json['normal_test_items'] as List?) ?? const [];
    final items = itemsRaw
        .whereType<Map>()
        .map((e) => NormalTestItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return LabTestDetail(
      name: (json['name'] ?? '').toString(),
      status: json['status']?.toString(),
      patient: json['patient']?.toString(),
      patientName: json['patient_name']?.toString(),
      patientAge: json['patient_age']?.toString(),
      patientSex: json['patient_sex']?.toString(),
      practitionerName: json['practitioner_name']?.toString(),
      department: json['department']?.toString(),
      company: json['company']?.toString(),
      resultDate: json['result_date']?.toString(),
      normalItems: items,
    );
  }
}
