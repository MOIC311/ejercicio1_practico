import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../proveedores/proveedor_tareas.dart';
import '../widgets/dialogo_tarea.dart';
import 'tareas_completadas_page.dart';
import 'tareas_pendientes_page.dart';
import 'todas_tareas_page.dart';

class TareasPage extends ConsumerStatefulWidget {
  const TareasPage({super.key});

  @override
  ConsumerState<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends ConsumerState<TareasPage> {
  static const _titulos = ['Mis tareas', 'Pendientes', 'Completadas'];
  int _indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titulos[_indiceSeleccionado],
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const Text(
              'Tu día, más organizado',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _indiceSeleccionado,
        children: const [
          TodasTareasPage(),
          TareasPendientesPage(),
          TareasCompletadasPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceSeleccionado,
        onDestinationSelected: (indice) {
          setState(() => _indiceSeleccionado = indice);
        },
        destinations: const [
          NavigationDestination(
            key: ValueKey('pestana-todas'),
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Todas',
          ),
          NavigationDestination(
            key: ValueKey('pestana-pendientes'),
            icon: Icon(Icons.pending_actions_outlined),
            selectedIcon: Icon(Icons.pending_actions),
            label: 'Pendientes',
          ),
          NavigationDestination(
            key: ValueKey('pestana-completadas'),
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Completadas',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('crear-tarea'),
        onPressed: _crearTarea,
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }

  Future<void> _crearTarea() async {
    final datos = await showDialog<DatosTarea>(
      context: context,
      builder: (_) => const FormularioTareaDialogo(),
    );
    if (datos == null || !mounted) return;

    try {
      await ref.read(tareasProvider.notifier).crearTarea(
            titulo: datos.titulo,
            descripcion: datos.descripcion,
          );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar la tarea. Inténtalo de nuevo.'),
        ),
      );
    }
  }
}
