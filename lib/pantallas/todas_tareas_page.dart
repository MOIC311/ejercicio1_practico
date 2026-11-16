import 'package:flutter/material.dart';

import '../widgets/lista_tareas.dart';

class TodasTareasPage extends StatelessWidget {
  const TodasTareasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListaTareas(filtro: FiltroTareas.todas);
  }
}
