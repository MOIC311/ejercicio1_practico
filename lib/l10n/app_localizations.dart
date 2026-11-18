import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis tareas'**
  String get appTitle;

  /// No description provided for @allTasksTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis tareas'**
  String get allTasksTitle;

  /// No description provided for @pendingTasksTitle.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get pendingTasksTitle;

  /// No description provided for @completedTasksTitle.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get completedTasksTitle;

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Tu día, más organizado'**
  String get appTagline;

  /// No description provided for @allTab.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get allTab;

  /// No description provided for @pendingTab.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get pendingTab;

  /// No description provided for @completedTab.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get completedTab;

  /// No description provided for @newTask.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarea'**
  String get newTask;

  /// No description provided for @saveTaskError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la tarea. Inténtalo de nuevo.'**
  String get saveTaskError;

  /// No description provided for @editTask.
  ///
  /// In es, this message translates to:
  /// **'Editar tarea'**
  String get editTask;

  /// No description provided for @taskTitle.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get taskTitle;

  /// No description provided for @taskTitleHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Preparar presentación'**
  String get taskTitleHint;

  /// No description provided for @taskTitleRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe un título'**
  String get taskTitleRequired;

  /// No description provided for @taskDescriptionOptional.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get taskDescriptionOptional;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @saveTask.
  ///
  /// In es, this message translates to:
  /// **'Guardar tarea'**
  String get saveTask;

  /// No description provided for @loadTasksError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar o guardar las tareas.'**
  String get loadTasksError;

  /// No description provided for @emptyAllTasks.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes tareas'**
  String get emptyAllTasks;

  /// No description provided for @emptyPendingTasks.
  ///
  /// In es, this message translates to:
  /// **'No tienes tareas pendientes'**
  String get emptyPendingTasks;

  /// No description provided for @emptyCompletedTasks.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has completado tareas'**
  String get emptyCompletedTasks;

  /// No description provided for @emptyTasksHint.
  ///
  /// In es, this message translates to:
  /// **'Pulsa «Nueva tarea» para comenzar.'**
  String get emptyTasksHint;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @allTasksDone.
  ///
  /// In es, this message translates to:
  /// **'¡Todo listo!'**
  String get allTasksDone;

  /// No description provided for @oneStepAtATime.
  ///
  /// In es, this message translates to:
  /// **'Un paso a la vez'**
  String get oneStepAtATime;

  /// No description provided for @tasksRemaining.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{No te quedan tareas} =1{Te queda 1 tarea} other{Te quedan {count} tareas}}'**
  String tasksRemaining(int count);

  /// No description provided for @taskProgress.
  ///
  /// In es, this message translates to:
  /// **'{completed}/{total}'**
  String taskProgress(int completed, int total);

  /// No description provided for @createdDate.
  ///
  /// In es, this message translates to:
  /// **'Creada {date}'**
  String createdDate(String date);

  /// No description provided for @taskOptions.
  ///
  /// In es, this message translates to:
  /// **'Opciones de {title}'**
  String taskOptions(String title);

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @deleteTask.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tarea'**
  String get deleteTask;

  /// No description provided for @confirmDeleteTask.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres eliminar \"{title}\"?'**
  String confirmDeleteTask(String title);

  /// No description provided for @operationError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar la operación. Inténtalo de nuevo.'**
  String get operationError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
