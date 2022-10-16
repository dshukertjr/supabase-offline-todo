import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@DataRepository([])
@JsonSerializable()
class Task extends DataModel<Task> {
  Task({
    this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  @override
  final String? id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
}
