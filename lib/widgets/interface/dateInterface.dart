// ignore_for_file: non_constant_identifier_names

class DateInterFace {
  final String name;
  final String date;
  final String id;

  const DateInterFace({
    required this.name,
    required this.id,
    required this.date,
  });

  factory DateInterFace.fromJson(Map<String, dynamic> json) {
    return DateInterFace(
      name: json['name'] as String,
      date: json['date'] as String,
      id: json['id'] as String,
    );
  }

  DateInterFace copy({
    String? date,
    String? name,
    String? id,
  }) =>
      DateInterFace(
        name: name ?? this.name,
        id: id ?? this.id,
        date: date ?? this.date,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateInterFace &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          date == other.date &&
          id == other.id;

  @override
  int get hashCode => date.hashCode ^ name.hashCode ^ id.hashCode;
}
