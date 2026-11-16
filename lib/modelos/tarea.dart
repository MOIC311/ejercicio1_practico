class Tarea {
  const Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.completada,
    required this.fechaCreacion,
  });

  final int id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final DateTime fechaCreacion;

  Tarea copiarCon({
    String? titulo,
    String? descripcion,
    bool? completada,
  }) {
    return Tarea(
      id: id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      completada: completada ?? this.completada,
      fechaCreacion: fechaCreacion,
    );
  }

  Map<String, Object?> aMapa() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': completada ? 1 : 0,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  factory Tarea.desdeMapa(Map<String, Object?> mapa) {
    return Tarea(
      id: mapa['id']! as int,
      titulo: mapa['titulo']! as String,
      descripcion: mapa['descripcion']! as String,
      completada: mapa['completada'] == 1,
      fechaCreacion: DateTime.parse(mapa['fecha_creacion']! as String),
    );
  }
}
