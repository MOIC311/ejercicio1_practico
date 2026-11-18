import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
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
                      ? l10n.allTasksDone
                      : l10n.oneStepAtATime,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: colores_app.Colors.blanco),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.tasksRemaining(pendientes),
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
              l10n.taskProgress(completadas, total),
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
