class Activity {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;

  Activity({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'status': status,
  };

  static Activity fromMap(Map<String, dynamic> map) => Activity(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    dueDate: DateTime.parse(map['dueDate']),
    status: map['status'],
  );

  Activity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? status,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }
}
