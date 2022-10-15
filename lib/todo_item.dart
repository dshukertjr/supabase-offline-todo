class TodoItem {
  TodoItem({
    required this.content,
    required this.isCompleted,
    required this.createdAt,
  });

  final String content;
  final bool isCompleted;
  final DateTime createdAt;
}
