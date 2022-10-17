import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offlinetodo/cubit/task_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Offline Caching Example',
      theme: ThemeData.light().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: BlocProvider<TaskCubit>(
        create: (context) => TaskCubit()..loadTasks(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
        if (state is TaskLoaded) {
          final tasks = state.tasks;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    final task = tasks[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      onDismissed: (_) async {
                        await BlocProvider.of<TaskCubit>(context)
                            .deleteTask(task.id);
                      },
                      background: const DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                      child: ListTile(
                        title: Text(task.title),
                      ),
                    );
                  }),
                ),
              ),
              const NewTaskComposer(),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

class NewTaskComposer extends StatefulWidget {
  const NewTaskComposer({super.key});

  @override
  State<NewTaskComposer> createState() => _NewTaskComposerState();
}

class _NewTaskComposerState extends State<NewTaskComposer> {
  final _taskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Create new task',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final title = _taskController.text;
              await BlocProvider.of<TaskCubit>(context).createTask(title);
              _taskController.clear();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
