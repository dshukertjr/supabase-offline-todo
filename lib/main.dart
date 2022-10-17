import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offlinetodo/main.data.dart';
import 'package:offlinetodo/task.dart';

void main() {
  runApp(ProviderScope(
    overrides: [configureRepositoryLocalStorage()],
    child: const MyApp(),
  ));
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
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(repositoryInitializerProvider).when(
            error: (error, _) => Text(error.toString()),
            loading: () => const CircularProgressIndicator(),
            data: (_) {
              ref.tasks.logLevel = 2;
              // final state = ref.tasks.watchAll();
              final state =
                  ref.tasks.watchAll(params: {'_limit': 5}, syncLocal: true);
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return TaskList(state: state);
            },
          ),
    );
  }
}

class TaskList extends ConsumerWidget {
  const TaskList({
    Key? key,
    required this.state,
  }) : super(key: key);

  final DataState<List<Task>?> state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.tasks.findAll(params: {'_limit': 5}, syncLocal: true),
            child: ListView(
              children: [
                for (final task in state.model!)
                  Dismissible(
                    key: ValueKey(task),
                    direction: DismissDirection.endToStart,
                    background: const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.red),
                    ),
                    onDismissed: (_) => task.delete(),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (value) => task.toggleCompleted().save(),
                      ),
                      title: Text('${task.title} [id: ${task.id}]'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const NewTaskComposer(),
      ],
    );
  }
}

class NewTaskComposer extends StatefulWidget {
  const NewTaskComposer({super.key});

  @override
  State<NewTaskComposer> createState() => _NewTaskComposerState();
}

class _NewTaskComposerState extends State<NewTaskComposer> {
  final _newTaskController = TextEditingController();

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _newTaskController,
        decoration: InputDecoration(
          hintText: 'Add a new task...',
          suffix: TextButton(
            onPressed: () {
              final value = _newTaskController.text;
              Task(
                title: value,
                completed: false,
              ).save();
              _newTaskController.clear();
            },
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }
}
