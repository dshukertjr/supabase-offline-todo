import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:offlinetodo/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'task_state.dart';

class TaskCubit extends HydratedCubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final supabase = Supabase.instance.client;
  StreamSubscription<List<Task>>? _streamSubscription;

  /// Setup a listener on Supabase to get the tasks
  void loadTasks() {
    _streamSubscription = supabase
        .from('tasks')
        .stream(['id'])
        .order('created_at', ascending: false)
        .map((rows) => rows.map(Task.fromMap).toList())
        .listen((tasks) {
          emit(TaskLoaded(tasks));
        }, onError: (error) async {
          // Upon failing to estabilish initial request, retry every second to reconnect
          _streamSubscription?.cancel();
          await Future.delayed(const Duration(seconds: 1));
          loadTasks();
        });
  }

  Future<void> createTask(String title) async {
    // Modify the local state before saving to Supabase
    final newTask = Task(id: id, title: title, createdAt: DateTime.now());
    final currentState = state;
    if (currentState is TaskLoaded) {
      final tasks = currentState.tasks;
      tasks.insert(0, newTask);
      emit(TaskLoaded(tasks));
    } else {
      emit(TaskLoaded([newTask]));
    }

    // Save data to Supabase
    await supabase.from('tasks').insert({'title': title});
  }

  Future<void> deleteTask(String id) async {
    // Modify the local state before saving to Supabase
    final currentState = state;
    if (currentState is TaskLoaded) {
      final tasks = currentState.tasks;
      tasks.removeWhere((task) => task.id == id);
      emit(TaskLoaded(tasks));
    }

    // Save data to Supabase
    await supabase.from('tasks').delete().eq('id', id);
  }

  /// json serialization for hydrated bloc
  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    if (json['tasks'] != null) {
      return TaskLoaded.fromJson(json);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
