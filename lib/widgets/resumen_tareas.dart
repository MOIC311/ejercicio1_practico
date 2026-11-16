import 'package:flutter/material.dart';

import '../recursos/colores_app.dart' as colores_app;

class ResumenTareas extends StatelessWidget {
  const ResumenTareas({
    required this.total,
    required this.completadas,
    super.key,
  });

  final int total;
  final int completadas;

  @override
  Widget build(BuildContext context) {
    final pendientes = total - completadas;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colores_app.Colors.primario,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pendientes == 0 && total > 0
                      ? '¡Todo listo!'
                      : 'Un paso a la vez',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: colores_app.Colors.blanco),
                ),
                const SizedBox(height: 6),
                Text(
                  pendientes == 1
                      ? 'Te queda 1 tarea'
                      : 'Te quedan $pendientes tareas',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colores_app.Colors.blanco.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$completadas/$total',
              style: const TextStyle(
                color: colores_app.Colors.blanco,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
