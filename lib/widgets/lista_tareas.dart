import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../modelos/tarea.dart';
import '../proveedores/proveedor_tareas.dart';
import 'dialogo_tarea.dart';
import 'error_tareas.dart';
import 'estado_vacio.dart';
import 'resumen_tareas.dart';
import 'tarjeta_tarea.dart';

enum FiltroTareas { todas, pendientes, completadas }

class ListaTareas extends ConsumerWidget {
  const ListaTareas({required this.filtro, super.key});

  final FiltroTareas filtro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final estado = ref.watch(tareasProvider);
    return estado.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorTareas(
        mensaje: l10n.loadTasksError,
        alReintentar: () => ref.invalidate(tareasProvider),
      ),
      data: (tareas) => _construirLista(context, ref, tareas, l10n),
    );
  }

  Widget _construirLista(
    BuildContext context,
    WidgetRef ref,
    List<Tarea> tareas,
    AppLocalizations l10n,
  ) {
    final completadas = tareas.where((tarea) => tarea.completada).length;
    final visibles = tareas.where((tarea) {
      return switch (filtro) {
        FiltroTareas.todas => true,
        FiltroTareas.pendientes => !tarea.completada,
        FiltroTareas.completadas => tarea.completada,
      };
    }).toList();

    if (visibles.isEmpty) {
      final (mensaje, icono) = switch (filtro) {
        FiltroTareas.todas => (l10n.emptyAllTasks, Icons.edit_note),
        FiltroTareas.pendientes => (
          l10n.emptyPendingTasks,
          Icons.check_circle_outline,
        ),
        FiltroTareas.completadas => (l10n.emptyCompletedTasks, Icons.task_alt),
      };
      return Column(
        children: [
          if (filtro == FiltroTareas.todas)
            ResumenTareas(total: tareas.length, completadas: completadas),
          Expanded(
            child: EstadoVacio(
              mensaje: mensaje,
              icono: icono,
              mostrarIndicacion: filtro == FiltroTareas.todas,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (filtro == FiltroTareas.todas)
          ResumenTareas(total: tareas.length, completadas: completadas),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: visibles.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final tarea = visibles[index];
              return TarjetaTarea(
                tarea: tarea,
                alCambiarEstado: (completada) => _ejecutarMutacion(
                  context,
                  () => ref
                      .read(tareasProvider.notifier)
                      .actualizarTarea(tarea.copiarCon(completada: completada)),
                ),
                alEditar: () => _editarTarea(context, ref, tarea),
                alEliminar: () => _eliminarTarea(context, ref, tarea),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _editarTarea(
    BuildContext context,
    WidgetRef ref,
    Tarea tarea,
  ) async {
    final datos = await showDialog<DatosTarea>(
      context: context,
      builder: (_) => FormularioTareaDialogo(tarea: tarea),
    );
    if (datos == null || !context.mounted) return;

    await _ejecutarMutacion(
      context,
      () => ref
          .read(tareasProvider.notifier)
          .actualizarTarea(
            tarea.copiarCon(
              titulo: datos.titulo,
              descripcion: datos.descripcion,
            ),
          ),
    );
  }

  Future<void> _eliminarTarea(
    BuildContext context,
    WidgetRef ref,
    Tarea tarea,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteTask),
        content: Text(
          AppLocalizations.of(context).confirmDeleteTask(tarea.titulo),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            key: const ValueKey('confirmar-eliminar-tarea'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
    if (confirmar != true || !context.mounted) return;

    await _ejecutarMutacion(
      context,
      () => ref.read(tareasProvider.notifier).eliminarTarea(tarea.id),
    );
  }

  Future<void> _ejecutarMutacion(
    BuildContext context,
    Future<void> Function() mutacion,
  ) async {
    try {
      await mutacion();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).operationError)),
      );
    }
  }
}
