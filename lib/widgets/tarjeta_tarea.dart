import 'package:flutter/material.dart';

import '../modelos/tarea.dart';
import '../recursos/colores_app.dart' as colores_app;

class TarjetaTarea extends StatelessWidget {
  const TarjetaTarea({
    required this.tarea,
    required this.alCambiarEstado,
    required this.alEditar,
    required this.alEliminar,
    super.key,
  });

  final Tarea tarea;
  final ValueChanged<bool> alCambiarEstado;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              key: ValueKey('tarea-completada-${tarea.id}'),
              value: tarea.completada,
              onChanged: (valor) => alCambiarEstado(valor ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tarea.titulo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : null,
                        color: tarea.completada
                            ? colores_app.Colors.textoSecundario
                            : null,
                      ),
                    ),
                    if (tarea.descripcion.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        tarea.descripcion,
                        style: TextStyle(
                          color: colores_app.Colors.textoSecundario,
                          decoration: tarea.completada
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Creada ${_formatearFecha(tarea.fechaCreacion)}',
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: colores_app.Colors.textoSecundario),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Opciones de ${tarea.titulo}',
              onSelected: (accion) {
                if (accion == 'editar') alEditar();
                if (accion == 'eliminar') alEliminar();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'editar',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Editar'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'eliminar',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Eliminar'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final local = fecha.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    return '$dia/$mes/${local.year}';
  }
}
