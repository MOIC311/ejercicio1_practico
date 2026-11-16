import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class BaseDatosTareas {
  BaseDatosTareas._();

  static final BaseDatosTareas instancia = BaseDatosTareas._();
  static const _nombreArchivo = 'tareas.db';
  static const _version = 1;

  Future<Database>? _baseDatos;

  Future<Database> get baseDatos async {
    final actual = _baseDatos;
    if (actual != null) return actual;

    final apertura = _abrirBaseDatos();
    _baseDatos = apertura;
    try {
      return await apertura;
    } catch (_) {
      if (identical(_baseDatos, apertura)) _baseDatos = null;
      rethrow;
    }
  }

  Future<Database> _abrirBaseDatos() async {
    final directorio = await getDatabasesPath();
    return openDatabase(
      path.join(directorio, _nombreArchivo),
      version: _version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tareas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT NOT NULL DEFAULT '',
            completada INTEGER NOT NULL DEFAULT 0
              CHECK (completada IN (0, 1)),
            fecha_creacion TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> cerrar() async {
    final apertura = _baseDatos;
    if (apertura == null) return;

    final db = await apertura;
    await db.close();
    _baseDatos = null;
  }
}
