import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datos/base_datos_tareas.dart';
import '../datos/repositorio_tareas.dart';
import '../modelos/tarea.dart';

final repositorioTareasProvider = Provider<RepositorioTareas>((ref) {
  return RepositorioTareasSqlite(BaseDatosTareas.instancia);
});

final tareasProvider =
    AsyncNotifierProvider<ControladorTareas, List<Tarea>>(
  ControladorTareas.new,
);

class ControladorTareas extends AsyncNotifier<List<Tarea>> {
  RepositorioTareas get _repositorio => ref.read(repositorioTareasProvider);

  @override
  Future<List<Tarea>> build() => _repositorio.obtenerTodas();

  Future<void> crearTarea({
    required String titulo,
    required String descripcion,
  }) async {
    await _mutar(() async {
      await _repositorio.crear(titulo: titulo, descripcion: descripcion);
    });
  }

  Future<void> actualizarTarea(Tarea tarea) async {
    await _mutar(() => _repositorio.actualizar(tarea));
  }

  Future<void> eliminarTarea(int id) async {
    await _mutar(() => _repositorio.eliminar(id));
  }

  Future<void> _mutar(Future<void> Function() operacion) async {
    try {
      await operacion();
      state = AsyncData(await _repositorio.obtenerTodas());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
