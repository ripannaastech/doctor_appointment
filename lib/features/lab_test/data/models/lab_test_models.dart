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

class LabTestTemplateItem {
  final int idx;
  final String? labTestName;
  final String? uom;
  final String? normalRange;

  LabTestTemplateItem({
    required this.idx,
    this.labTestName,
    this.uom,
    this.normalRange,
  });

  factory LabTestTemplateItem.fromJson(Map<String, dynamic> json) {
    int idx = 0;
    final rawIdx = json['idx'];
    if (rawIdx is int) idx = rawIdx;
    else idx = int.tryParse((rawIdx ?? '').toString()) ?? 0;

    return LabTestTemplateItem(
      idx: idx,
      labTestName: json['lab_test_name']?.toString() ??
          json['test_name']?.toString() ??
          json['parameter']?.toString(),
      uom: json['lab_test_uom']?.toString() ??
          json['uom']?.toString() ??
          json['unit']?.toString(),
      normalRange: json['normal_range']?.toString() ??
          json['reference_range']?.toString() ??
          json['range']?.toString(),
    );
  }
}

class NormalTestItem {
  final String name;
  final int idx;

  final String? labTestName;
  final String? uom;
  final String? normalRange;
  final int? requireResultValue;
  final String? resultValue;

  NormalTestItem({
    required this.name,
    required this.idx,
    this.labTestName,
    this.uom,
    this.normalRange,
    this.requireResultValue,
    this.resultValue,
  });

  NormalTestItem copyWith({
    String? labTestName,
    String? uom,
    String? normalRange,
    String? resultValue,
    int? requireResultValue,
  }) {
    return NormalTestItem(
      name: name,
      idx: idx,
      labTestName: labTestName ?? this.labTestName,
      uom: uom ?? this.uom,
      normalRange: normalRange ?? this.normalRange,
      requireResultValue: requireResultValue ?? this.requireResultValue,
      resultValue: resultValue ?? this.resultValue,
    );
  }

  factory NormalTestItem.fromJson(Map<String, dynamic> json) {
    String? rv;
    if (json['result_value'] != null) rv = json['result_value'].toString();
    if (rv == null && json['result'] != null) rv = json['result'].toString();
    if (rv == null && json['value'] != null) rv = json['value'].toString();

    int idx = 0;
    final rawIdx = json['idx'];
    if (rawIdx is int) idx = rawIdx;
    else idx = int.tryParse((rawIdx ?? '').toString()) ?? 0;

    return NormalTestItem(
      name: (json['name'] ?? '').toString(),
      idx: idx,
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
  final String? template; // ✅ important
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
    this.template,
    required this.normalItems,
  });

  factory LabTestDetail.fromJson(Map<String, dynamic> json) {
    final itemsRaw = (json['normal_test_items'] as List?) ?? const [];
    final items = itemsRaw
        .whereType<Map>()
        .map((e) => NormalTestItem.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.idx.compareTo(b.idx));

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
      template: json['template']?.toString(), // ✅
      normalItems: items,
    );
  }
}
