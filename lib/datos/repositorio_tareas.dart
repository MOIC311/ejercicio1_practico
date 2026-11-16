import '../modelos/tarea.dart';
import 'base_datos_tareas.dart';

abstract interface class RepositorioTareas {
  Future<List<Tarea>> obtenerTodas();
  Future<Tarea> crear({
    required String titulo,
    required String descripcion,
  });
  Future<void> actualizar(Tarea tarea);
  Future<void> eliminar(int id);
}

class RepositorioTareasSqlite implements RepositorioTareas {
  RepositorioTareasSqlite(this._baseDatos);

  final BaseDatosTareas _baseDatos;

  @override
  Future<List<Tarea>> obtenerTodas() async {
    final db = await _baseDatos.baseDatos;
    final filas = await db.query(
      'tareas',
      orderBy: 'fecha_creacion DESC, id DESC',
    );
    return filas.map(Tarea.desdeMapa).toList(growable: false);
  }

  @override
  Future<Tarea> crear({
    required String titulo,
    required String descripcion,
  }) async {
    final db = await _baseDatos.baseDatos;
    final fechaCreacion = DateTime.now();
    final id = await db.insert('tareas', {
      'titulo': titulo.trim(),
      'descripcion': descripcion.trim(),
      'completada': 0,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    });
    return Tarea(
      id: id,
      titulo: titulo.trim(),
      descripcion: descripcion.trim(),
      completada: false,
      fechaCreacion: fechaCreacion,
    );
  }

  @override
  Future<void> actualizar(Tarea tarea) async {
    final db = await _baseDatos.baseDatos;
    final filasActualizadas = await db.update(
      'tareas',
      tarea.aMapa()..remove('id'),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
    if (filasActualizadas != 1) {
      throw StateError('No se encontró la tarea ${tarea.id} para actualizar.');
    }
  }

  @override
  Future<void> eliminar(int id) async {
    final db = await _baseDatos.baseDatos;
    final filasEliminadas = await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (filasEliminadas != 1) {
      throw StateError('No se encontró la tarea $id para eliminar.');
    }
  }
}
