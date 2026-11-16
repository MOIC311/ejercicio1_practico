# Lista de tareas offline-first

Aplicación móvil Flutter para administrar tareas sin depender de un servidor ni
de una conexión a internet. Los datos se guardan en SQLite en el dispositivo y
la interfaz observa el estado administrado por Riverpod.

## Funcionalidad

- Crear una tarea con título obligatorio y descripción opcional.
- Listar todas las tareas y filtrar por pendientes o completadas.
- Marcar una tarea como completada o volverla a pendiente.
- Editar el título y la descripción sin cambiar su fecha de creación ni su
  estado.
- Eliminar una tarea después de confirmar la acción.
- Mostrar estados de carga, error y lista vacía.
- Reflejar las operaciones de base de datos en la interfaz sin recargar la
  aplicación manualmente.

El formulario limita el título a 80 caracteres y la descripción a 240. La
validación del título se realiza en la interfaz; el repositorio recorta los
espacios exteriores antes de guardar. La descripción vacía se almacena como una
cadena vacía y no como `NULL`.

## Decisiones de arquitectura

Se utiliza una separación por responsabilidades, manteniendo las dependencias
en una sola dirección:

```text
Pantallas y widgets
        ↓ leen/escriben
Controlador Riverpod (AsyncNotifier)
        ↓ depende de la abstracción
Contrato del repositorio
        ↓ implementado por
Repositorio SQLite
        ↓ usa
Conexión y esquema SQLite
```

La UI no ejecuta sentencias SQL. El proveedor depende de `RepositorioTareas`,
una abstracción que también permite sustituir SQLite por una implementación
falsa durante las pruebas. El repositorio es el punto único de acceso a los
datos y la clase de base de datos centraliza la conexión y el esquema.

### Estado con Riverpod

`tareasProvider` es un `AsyncNotifierProvider<ControladorTareas, List<Tarea>>`:

1. `build()` obtiene la lista inicial del repositorio; durante esta lectura la
   pantalla presenta un indicador de carga.
2. Las acciones de crear, actualizar y eliminar se ejecutan en el controlador.
3. Al concluir cada escritura, el controlador vuelve a consultar el repositorio
   y publica una nueva lista con `AsyncData`.
4. Si la operación falla, publica `AsyncError` y vuelve a propagar el error.
   La UI informa el fallo y permite reintentar la lectura inicial.

Las páginas de todas, pendientes y completadas observan el mismo proveedor.
Aplican el filtro en memoria a la lista local, por lo que cambiar de pestaña no
requiere otra consulta SQL ni una conexión a internet. `IndexedStack` conserva
las páginas y el `NavigationBar` cambia entre ellas. El estado del filtro de
navegación es estado efímero de interfaz; los datos de las tareas pertenecen al
controlador Riverpod.

### Modelo y persistencia

El modelo `Tarea` contiene:

| Campo | Tipo en Dart | Columna SQLite | Regla |
| --- | --- | --- | --- |
| `id` | `int` | `INTEGER` | Clave primaria autoincremental |
| `titulo` | `String` | `TEXT` | Obligatorio |
| `descripcion` | `String` | `TEXT` | Obligatorio; valor inicial vacío |
| `completada` | `bool` | `INTEGER` | Obligatorio; `0` o `1` |
| `fechaCreacion` | `DateTime` | `TEXT` | Obligatorio; ISO 8601 |

La tabla tiene una restricción `CHECK` para impedir valores distintos de `0` y
`1` en `completada`. Las tareas se ordenan de más recientes a más antiguas por
fecha de creación, usando el identificador como desempate.

`BaseDatosTareas` mantiene una única instancia de la apertura asíncrona para
evitar abrir varias conexiones simultáneas. Si la apertura falla, permite
reintentarla; también ofrece `cerrar()` para cerrar la conexión. La base se crea
con versión `1`. Si se modifica el esquema en versiones posteriores, se debe
incrementar la versión y añadir una migración `onUpgrade` que preserve los datos
existentes.

La fecha se genera en el dispositivo al crear la tarea y se almacena como texto
ISO 8601. No se usa un servidor como fuente de tiempo. No se implementa
sincronización entre dispositivos, exportación ni copia de seguridad remota.

## Estructura del proyecto

```text
lib/
├── main.dart
├── datos/
│   ├── base_datos_tareas.dart
│   └── repositorio_tareas.dart
├── modelos/
│   └── tarea.dart
├── pantallas/
│   ├── tareas_page.dart
│   ├── todas_tareas_page.dart
│   ├── tareas_pendientes_page.dart
│   └── tareas_completadas_page.dart
├── proveedores/
│   └── proveedor_tareas.dart
├── recursos/
│   ├── colores_app.dart
│   ├── fuentes_app.dart
│   └── tema_app.dart
└── widgets/
    ├── dialogo_tarea.dart
    ├── error_tareas.dart
    ├── estado_vacio.dart
    ├── lista_tareas.dart
    ├── resumen_tareas.dart
    └── tarjeta_tarea.dart
```

- **`datos/`**: conexión SQLite, creación de tabla, contrato e implementación
  del repositorio.
- **`modelos/`**: entidad de tarea y conversión a/desde filas de SQLite.
- **`proveedores/`**: proveedor de dependencias y controlador asíncrono.
- **`pantallas/`**: estructura de navegación y páginas para cada filtro.
- **`widgets/`**: componentes de presentación reutilizables, formulario y
  estados visuales.
- **`recursos/`**: paleta de colores, tipografía y tema Material.

Los nombres de carpetas, archivos y símbolos de dominio están en español para
mantener una convención consistente. Los widgets se extraen a archivos propios
para reducir la complejidad por archivo y facilitar su lectura, mantenimiento y
prueba; esta modularidad no pretende reducir por sí sola el tamaño del APK.

## Paquetes y justificación

| Paquete | Uso |
| --- | --- |
| `flutter_riverpod` | Contenedor de dependencias y estado reactivo con `AsyncNotifier`; permite inyectar un repositorio falso en pruebas de widgets. |
| `sqflite` | Base SQLite nativa para persistencia local en Android e iOS. |
| `path` | Construye la ruta de `tareas.db` de forma compatible con la plataforma, evitando concatenación manual de separadores. |
| `flutter_lints` | Reglas estáticas de estilo y calidad de Dart/Flutter. |
| `flutter_test` | Pruebas de widgets y flujos de interacción. |

No se agregan `freezed`, `uuid` ni `intl`: el modelo es pequeño, SQLite asigna
identificadores enteros y la fecha se presenta con un formato numérico sencillo.
Se retiró `cupertino_icons`, incluido en la plantilla Flutter inicial, porque la
interfaz actual usa iconos Material y no lo necesita.

## Plataformas

El almacenamiento configurado mediante `sqflite` está dirigido a Android e
iOS. El proyecto también contiene scaffolding de escritorio y web de Flutter,
pero esta implementación no declara soporte de persistencia SQLite para esas
plataformas. La tipografía Roboto se obtiene del sistema y no requiere descargar
fuentes ni recursos externos.

## Ejecutar

Desde la raíz del proyecto:

```shell
flutter pub get
flutter run
```

Para seleccionar explícitamente un emulador Android conectado:

```shell
flutter devices
flutter run -d <id-del-emulador>
```

## Pruebas y análisis

```shell
flutter test
flutter analyze
flutter build apk --debug
```

La prueba de widgets sustituye `RepositorioTareas` por una implementación en
memoria; cubre creación, cambio de estado, navegación entre filtros, edición y
eliminación, sin depender de plugins nativos durante la prueba.
