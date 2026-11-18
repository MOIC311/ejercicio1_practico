// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mis tareas';

  @override
  String get allTasksTitle => 'Mis tareas';

  @override
  String get pendingTasksTitle => 'Pendientes';

  @override
  String get completedTasksTitle => 'Completadas';

  @override
  String get appTagline => 'Tu día, más organizado';

  @override
  String get allTab => 'Todas';

  @override
  String get pendingTab => 'Pendientes';

  @override
  String get completedTab => 'Completadas';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get saveTaskError =>
      'No se pudo guardar la tarea. Inténtalo de nuevo.';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get taskTitle => 'Título';

  @override
  String get taskTitleHint => 'Ej. Preparar presentación';

  @override
  String get taskTitleRequired => 'Escribe un título';

  @override
  String get taskDescriptionOptional => 'Descripción (opcional)';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get saveTask => 'Guardar tarea';

  @override
  String get loadTasksError => 'No se pudieron cargar o guardar las tareas.';

  @override
  String get emptyAllTasks => 'Aún no tienes tareas';

  @override
  String get emptyPendingTasks => 'No tienes tareas pendientes';

  @override
  String get emptyCompletedTasks => 'Todavía no has completado tareas';

  @override
  String get emptyTasksHint => 'Pulsa «Nueva tarea» para comenzar.';

  @override
  String get retry => 'Reintentar';

  @override
  String get allTasksDone => '¡Todo listo!';

  @override
  String get oneStepAtATime => 'Un paso a la vez';

  @override
  String tasksRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Te quedan $count tareas',
      one: 'Te queda 1 tarea',
      zero: 'No te quedan tareas',
    );
    return '$_temp0';
  }

  @override
  String taskProgress(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String createdDate(String date) {
    return 'Creada $date';
  }

  @override
  String taskOptions(String title) {
    return 'Opciones de $title';
  }

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteTask => 'Eliminar tarea';

  @override
  String confirmDeleteTask(String title) {
    return '¿Quieres eliminar \"$title\"?';
  }

  @override
  String get operationError =>
      'No se pudo completar la operación. Inténtalo de nuevo.';
}
