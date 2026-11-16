import 'package:flutter/material.dart';

import '../widgets/lista_tareas.dart';

class TareasPendientesPage extends StatelessWidget {
  const TareasPendientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListaTareas(filtro: FiltroTareas.pendientes);
  }
}
