import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offlinetodo/adaptor.dart';

part 'task.g.dart';

@DataRepository([JsonServerAdapter])
@JsonSerializable()
class Task extends DataModel<Task> {
  Task({
    this.id,
    required this.title,
    required this.completed,
  });

  @override
  final int? id;
  final String title;
  final bool completed;
}
