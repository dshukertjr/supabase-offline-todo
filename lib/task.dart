/// Task model to hold individual tasks.
class Task {
  Task({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
