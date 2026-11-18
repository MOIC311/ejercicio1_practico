// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My tasks';

  @override
  String get allTasksTitle => 'My tasks';

  @override
  String get pendingTasksTitle => 'Pending';

  @override
  String get completedTasksTitle => 'Completed';

  @override
  String get appTagline => 'A more organized day';

  @override
  String get allTab => 'All';

  @override
  String get pendingTab => 'Pending';

  @override
  String get completedTab => 'Completed';

  @override
  String get newTask => 'New task';

  @override
  String get saveTaskError => 'Couldn\'t save the task. Please try again.';

  @override
  String get editTask => 'Edit task';

  @override
  String get taskTitle => 'Title';

  @override
  String get taskTitleHint => 'E.g. Prepare a presentation';

  @override
  String get taskTitleRequired => 'Enter a title';

  @override
  String get taskDescriptionOptional => 'Description (optional)';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saveTask => 'Save task';

  @override
  String get loadTasksError => 'Couldn\'t load or save the tasks.';

  @override
  String get emptyAllTasks => 'You don\'t have any tasks yet';

  @override
  String get emptyPendingTasks => 'You don\'t have any pending tasks';

  @override
  String get emptyCompletedTasks => 'You haven\'t completed any tasks yet';

  @override
  String get emptyTasksHint => 'Tap \"New task\" to get started.';

  @override
  String get retry => 'Retry';

  @override
  String get allTasksDone => 'All done!';

  @override
  String get oneStepAtATime => 'One step at a time';

  @override
  String tasksRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks left',
      one: '1 task left',
      zero: 'No tasks left',
    );
    return '$_temp0';
  }

  @override
  String taskProgress(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String createdDate(String date) {
    return 'Created $date';
  }

  @override
  String taskOptions(String title) {
    return 'Options for $title';
  }

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTask => 'Delete task';

  @override
  String confirmDeleteTask(String title) {
    return 'Do you want to delete \"$title\"?';
  }

  @override
  String get operationError =>
      'Couldn\'t complete the operation. Please try again.';
}
