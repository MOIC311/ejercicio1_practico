import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../recursos/colores_app.dart' as colores_app;

class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    required this.mensaje,
    required this.icono,
    this.mostrarIndicacion = false,
    super.key,
  });

  final String mensaje;
  final IconData icono;
  final bool mostrarIndicacion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: colores_app.Colors.primario),
            const SizedBox(height: 12),
            Text(
              mensaje,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (mostrarIndicacion) ...[
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context).emptyTasksHint,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colores_app.Colors.textoSecundario),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
