import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:offlinetodo/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final supabase = Supabase.instance.client;
  late final StreamSubscription<List<Task>> _streamSubscription;

  void loadTasks() {
    _streamSubscription = supabase
        .from('tasks')
        .stream(['id'])
        .map((rows) => rows.map(Task.fromMap).toList())
        .listen((tasks) {
          emit(TaskLoaded(tasks));
        });
  }

  Future<void> createTask(String title) {
    return supabase.from('tasks').insert({'title': title});
  }

  Future<void> deleteTask(String id) {
    return supabase.from('tasks').delete().eq('id', id);
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
