import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final estado = ref.watch(tareasProvider);
    return estado.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorTareas(
        mensaje: 'No se pudieron cargar o guardar las tareas.',
        alReintentar: () => ref.invalidate(tareasProvider),
      ),
      data: (tareas) => _construirLista(context, ref, tareas),
    );
  }

  Widget _construirLista(
    BuildContext context,
    WidgetRef ref,
    List<Tarea> tareas,
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
        FiltroTareas.todas => ('Aún no tienes tareas', Icons.edit_note),
        FiltroTareas.pendientes => (
            'No tienes tareas pendientes',
            Icons.check_circle_outline,
          ),
        FiltroTareas.completadas => (
            'Todavía no has completado tareas',
            Icons.task_alt,
          ),
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
                  () => ref.read(tareasProvider.notifier).actualizarTarea(
                        tarea.copiarCon(completada: completada),
                      ),
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
      () => ref.read(tareasProvider.notifier).actualizarTarea(
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
        title: const Text('Eliminar tarea'),
        content: Text('¿Quieres eliminar "${tarea.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const ValueKey('confirmar-eliminar-tarea'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
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
        const SnackBar(
          content: Text('No se pudo completar la operación. Inténtalo de nuevo.'),
        ),
      );
    }
  }
}
