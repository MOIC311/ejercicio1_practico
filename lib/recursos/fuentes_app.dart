import 'package:flutter/material.dart';

abstract final class FuentesApp {
  static const String familia = 'Roboto';

  static TextTheme aplicar(TextTheme base) {
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
