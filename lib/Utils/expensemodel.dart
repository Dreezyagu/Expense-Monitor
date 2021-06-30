class Expensemodel {
  final String id;
  final int value;
  final String description;
  final String date;

  Expensemodel(
      {required this.id,
      required this.value,
      required this.description,
      required this.date});

  factory Expensemodel.fromJson(Map<String, dynamic> json) => Expensemodel(
        id: json['id'],
        value: json["value"],
        description: json["description"],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "value": value,
        "description": description,
        'date': date,
      };
}
