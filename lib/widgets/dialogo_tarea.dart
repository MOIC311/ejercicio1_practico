import 'package:flutter/material.dart';

import '../modelos/tarea.dart';

class DatosTarea {
  const DatosTarea({required this.titulo, required this.descripcion});

  final String titulo;
  final String descripcion;
}

class FormularioTareaDialogo extends StatefulWidget {
  const FormularioTareaDialogo({this.tarea, super.key});

  final Tarea? tarea;

  @override
  State<FormularioTareaDialogo> createState() =>
      _FormularioTareaDialogoState();
}

class _FormularioTareaDialogoState extends State<FormularioTareaDialogo> {
  late final TextEditingController _controladorTitulo;
  late final TextEditingController _controladorDescripcion;
  final _claveFormulario = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controladorTitulo = TextEditingController(text: widget.tarea?.titulo ?? '');
    _controladorDescripcion =
        TextEditingController(text: widget.tarea?.descripcion ?? '');
  }

  @override
  void dispose() {
    _controladorTitulo.dispose();
    _controladorDescripcion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.tarea != null;
    return AlertDialog(
      title: Text(esEdicion ? 'Editar tarea' : 'Nueva tarea'),
      content: Form(
        key: _claveFormulario,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const ValueKey('campo-titulo-tarea'),
                controller: _controladorTitulo,
                autofocus: true,
                maxLength: 80,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ej. Preparar presentación',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Escribe un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                key: const ValueKey('campo-descripcion-tarea'),
                controller: _controladorDescripcion,
                maxLines: 3,
                maxLength: 240,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const ValueKey('guardar-tarea'),
          onPressed: _guardar,
          child: Text(esEdicion ? 'Guardar cambios' : 'Guardar tarea'),
        ),
      ],
    );
  }

  void _guardar() {
    if (!_claveFormulario.currentState!.validate()) return;
    Navigator.pop(
      context,
      DatosTarea(
        titulo: _controladorTitulo.text.trim(),
        descripcion: _controladorDescripcion.text.trim(),
      ),
    );
  }
}
