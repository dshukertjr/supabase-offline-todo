import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:offlinetodo/cubit/task_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pxbyaepzmmevejtkkmmf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4YnlhZXB6bW1ldmVqdGtrbW1mIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjU5NjkyMjcsImV4cCI6MTk4MTU0NTIyN30.RIU6mT-LxG4Nx_dg9i8ebaDs9R4QFVYrmVN_-uYQYYI',
  );
  final storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());
  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
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

/// Main page presented to the user.
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
                  itemCount: tasks.length,
                  itemBuilder: ((context, index) {
                    final task = tasks[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      onDismissed: (_) {
                        BlocProvider.of<TaskCubit>(context).deleteTask(task.id);
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

/// Form field and a button to compose a new task.
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
      child: Material(
        color: const Color(0xFFEEEEEE),
        child: Padding(
          padding: EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
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
                  BlocProvider.of<TaskCubit>(context).createTask(title);
                  _taskController.clear();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
