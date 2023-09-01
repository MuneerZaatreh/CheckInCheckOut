class WorkMonthInterFace {
  final String link;
  final String date;

  const WorkMonthInterFace({
    required this.link,
    required this.date,
  });

  factory WorkMonthInterFace.fromJson(Map<String, dynamic> json) {
    return WorkMonthInterFace(
      link: json['link'] as String,
      date: json['date'] as String,
    );
  }

  WorkMonthInterFace copy({
    String? date,
    String? link,
  }) =>
      WorkMonthInterFace(
        link: link ?? this.link,
        date: date ?? this.date,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkMonthInterFace &&
          runtimeType == other.runtimeType &&
          link == other.link &&
          date == other.date;

  @override
  int get hashCode => date.hashCode ^ link.hashCode;
}
