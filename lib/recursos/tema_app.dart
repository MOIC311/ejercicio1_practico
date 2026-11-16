import 'package:flutter/material.dart' hide Colors;

import 'colores_app.dart' as app_colores;
import 'fuentes_app.dart';

abstract final class TemaApp {
  static final ThemeData claro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: app_colores.Colors.primario,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: app_colores.Colors.fondo,
    fontFamily: FuentesApp.familia,
    textTheme: FuentesApp.aplicar(ThemeData.light().textTheme),
    cardTheme: CardThemeData(
      color: app_colores.Colors.superficie,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
  );
}
