import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pantallas/tareas_page.dart';
import 'recursos/tema_app.dart';

void main() {
  runApp(const ProviderScope(child: TodoApp()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis tareas',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      home: const TareasPage(),
    );
  }
}
