import 'package:ejercicio1_practico/datos/repositorio_tareas.dart';
import 'package:ejercicio1_practico/main.dart';
import 'package:ejercicio1_practico/modelos/tarea.dart';
import 'package:ejercicio1_practico/proveedores/proveedor_tareas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('crea y marca una tarea como completada', (tester) async {
    final repository = _MemoryTaskRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [repositorioTareasProvider.overrideWithValue(repository)],
        child: const TodoApp(locale: Locale('es')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Aún no tienes tareas'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('crear-tarea')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('campo-titulo-tarea')),
      'Comprar fruta',
    );
    await tester.tap(find.byKey(const ValueKey('guardar-tarea')));
    await tester.pumpAndSettle();

    expect(find.text('Comprar fruta'), findsOneWidget);
    expect(repository.tasks, hasLength(1));

    await tester.tap(find.byKey(const ValueKey('tarea-completada-1')));
    await tester.pumpAndSettle();

    expect(repository.tasks.single.completada, isTrue);
    expect(find.text('¡Todo listo!'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('pestana-pendientes')));
    await tester.pumpAndSettle();
    expect(find.text('No tienes tareas pendientes'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('pestana-completadas')));
    await tester.pumpAndSettle();
    expect(find.text('Comprar fruta'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('pestana-todas')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Opciones de Comprar fruta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('campo-titulo-tarea')),
      'Comprar verduras',
    );
    await tester.tap(find.byKey(const ValueKey('guardar-tarea')));
    await tester.pumpAndSettle();

    expect(find.text('Comprar verduras'), findsOneWidget);
    expect(repository.tasks.single.completada, isTrue);

    await tester.tap(find.byTooltip('Opciones de Comprar verduras'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirmar-eliminar-tarea')));
    await tester.pumpAndSettle();

    expect(repository.tasks, isEmpty);
    expect(find.text('Aún no tienes tareas'), findsOneWidget);
  });

  testWidgets('muestra la interfaz en el idioma del dispositivo', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositorioTareasProvider.overrideWithValue(_MemoryTaskRepository()),
        ],
        child: const TodoApp(locale: Locale('en', 'US')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My tasks'), findsOneWidget);
    expect(find.text('New task'), findsOneWidget);
  });
}

class _MemoryTaskRepository implements RepositorioTareas {
  final List<Tarea> tasks = [];
  int _nextId = 1;

  @override
  Future<List<Tarea>> obtenerTodas() async => List.unmodifiable(tasks);

  @override
  Future<Tarea> crear({
    required String titulo,
    required String descripcion,
  }) async {
    final tarea = Tarea(
      id: _nextId++,
      titulo: titulo,
      descripcion: descripcion,
      completada: false,
      fechaCreacion: DateTime(2026, 1, 1),
    );
    tasks.add(tarea);
    return tarea;
  }

  @override
  Future<void> actualizar(Tarea tarea) async {
    final index = tasks.indexWhere((item) => item.id == tarea.id);
    if (index < 0) throw StateError('Tarea no encontrada');
    tasks[index] = tarea;
  }

  @override
  Future<void> eliminar(int id) async {
    tasks.removeWhere((tarea) => tarea.id == id);
  }
}
