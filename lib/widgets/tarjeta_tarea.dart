import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
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
                      l10n.createdDate(
                        MaterialLocalizations.of(context)
                            .formatCompactDate(tarea.fechaCreacion.toLocal()),
                      ),
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: colores_app.Colors.textoSecundario),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: l10n.taskOptions(tarea.titulo),
              onSelected: (accion) {
                if (accion == 'editar') alEditar();
                if (accion == 'eliminar') alEliminar();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'editar',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text(l10n.edit),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'eliminar',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text(l10n.delete),
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
}
