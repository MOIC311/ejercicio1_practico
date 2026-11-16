import 'package:flutter/material.dart';

import '../widgets/lista_tareas.dart';

class TareasCompletadasPage extends StatelessWidget {
  const TareasCompletadasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListaTareas(filtro: FiltroTareas.completadas);
  }
}
