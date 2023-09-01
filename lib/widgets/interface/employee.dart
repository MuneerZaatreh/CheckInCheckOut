// ignore_for_file: non_constant_identifier_names

class EmployeeInterFace {
  final String name;
  final String phone;
  final String id;
  final int status;

  const EmployeeInterFace({
    required this.phone,
    required this.name,
    required this.id,
    required this.status,
  });

  factory EmployeeInterFace.fromJson(Map<String, dynamic> json) {
    return EmployeeInterFace(
      name: json['name'] as String,
      phone: json['phone'] as String,
      id: json['id'] as String,
      status: json['status'] as int,
    );
  }

  EmployeeInterFace copy({
    String? phone,
    String? name,
    String? id,
    int? status,
  }) =>
      EmployeeInterFace(
          name: name ?? this.name,
          id: id ?? this.id,
          phone: phone ?? this.phone,
          status: status ?? this.status);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeInterFace &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          phone == other.phone &&
          id == other.id &&
          status == other.status;

  @override
  int get hashCode =>
      phone.hashCode ^ name.hashCode ^ status.hashCode ^ id.hashCode;
}
