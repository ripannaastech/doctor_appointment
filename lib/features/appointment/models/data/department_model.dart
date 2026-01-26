class Department {
  final String? name;
  final String? department;
  final String? doctype;

  Department({this.name, this.department, this.doctype});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      name: json['name']?.toString(),
      department: json['department']?.toString(),
      doctype: json['doctype']?.toString(),
    );
  }

  String get displayName => (department ?? name ?? '').trim();
}
