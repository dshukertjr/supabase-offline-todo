part of 'task_cubit.dart';

@immutable
abstract class TaskState {
  Map<String, dynamic> toJson();
}

/// Initial state. User will see a spinner during this state
class TaskInitial extends TaskState {
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

/// State for when ther tasks have been loaded.
class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);

  @override
  Map<String, dynamic> toJson() {
    return {
      'tasks': tasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TaskLoaded.fromJson(Map<String, dynamic> map) {
    return TaskLoaded(
      List<Task>.from(map['tasks']?.map((x) => Task.fromMap(x))),
    );
  }
}
