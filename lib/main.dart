import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offlinetodo/main.data.dart';

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
    return const MaterialApp(
      title: 'Supabase Offline Caching Example',
      home: HomePage(),
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
              final state = ref.tasks.watchAll();
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: [
                  for (final task in state.model!)
                    ListTile(title: Text(task.title)),
                ],
              );
            },
          ),
    );
  }
}
