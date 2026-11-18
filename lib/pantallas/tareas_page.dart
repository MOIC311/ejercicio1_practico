import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
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
  int _indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titulo = switch (_indiceSeleccionado) {
      0 => l10n.allTasksTitle,
      1 => l10n.pendingTasksTitle,
      _ => l10n.completedTasksTitle,
    };
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              l10n.appTagline,
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
        destinations: [
          NavigationDestination(
            key: ValueKey('pestana-todas'),
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: l10n.allTab,
          ),
          NavigationDestination(
            key: ValueKey('pestana-pendientes'),
            icon: Icon(Icons.pending_actions_outlined),
            selectedIcon: Icon(Icons.pending_actions),
            label: l10n.pendingTab,
          ),
          NavigationDestination(
            key: ValueKey('pestana-completadas'),
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: l10n.completedTab,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('crear-tarea'),
        onPressed: _crearTarea,
        icon: const Icon(Icons.add),
        label: Text(l10n.newTask),
      ),
    );
  }

  Future<void> _crearTarea() async {
    final datos = await showDialog<DatosTarea>(
      context: context,
      builder: (_) => const FormularioTareaDialogo(),
    );
    if (datos == null || !mounted) return;

    final mensajeError = AppLocalizations.of(context).saveTaskError;
    try {
      await ref
          .read(tareasProvider.notifier)
          .crearTarea(titulo: datos.titulo, descripcion: datos.descripcion);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensajeError)));
    }
  }
}
