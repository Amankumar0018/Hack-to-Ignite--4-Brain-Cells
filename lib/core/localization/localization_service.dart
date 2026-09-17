import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import 'app_language.dart';

/// Centralized service managing application localization, state persistence,
/// runtime language switching, and voice speech recognition locale mapping.
class LocalizationService extends ChangeNotifier {
  static const String storageKey = 'pukaar_selected_language';
  static const String legacyStorageKey = 'app_language_code';

  final StorageService? _storageService;

  AppLanguage _currentLanguage = AppLanguage.english;
  Locale _currentLocale = AppLanguage.english.locale;
  bool _isInitialized = false;

  LocalizationService([this._storageService]);

  /// Currently active language.
  AppLanguage get currentLanguage => _currentLanguage;

  /// Currently active [Locale].
  Locale get currentLocale => _currentLocale;

  /// Whether the service has completed storage restoration.
  bool get isInitialized => _isInitialized;

  /// Supported application locales for Flutter MaterialApp.
  static List<Locale> get supportedLocales =>
      AppLanguage.values.map((lang) => lang.locale).toList();

  /// Maps the active (or requested) language to its device speech recognition locale.
  ///
  /// English -> 'en_IN'
  /// Hindi -> 'hi_IN'
  /// Marathi -> 'mr_IN'
  String getSpeechLocale([AppLanguage? language]) {
    final targetLang = language ?? _currentLanguage;
    return targetLang.speechLocale;
  }

  /// Current speech recognition locale ID for active language.
  String get currentSpeechLocale => getSpeechLocale(_currentLanguage);

  /// Initializes language preference from storage during app bootstrap.
  ///
  /// Defaults gracefully to English if no preference was previously saved.
  Future<void> init() async {
    try {
      String? savedCode;
      if (_storageService != null) {
        savedCode = await _storageService.getString(storageKey) ??
            await _storageService.getString(legacyStorageKey);
      }
      if (savedCode == null || savedCode.isEmpty) {
        try {
          final prefs = await SharedPreferences.getInstance();
          savedCode = prefs.getString(storageKey) ?? prefs.getString(legacyStorageKey);
        } catch (_) {}
      }

      if (savedCode != null && savedCode.isNotEmpty) {
        _currentLanguage = AppLanguage.fromCode(savedCode);
        _currentLocale = _currentLanguage.locale;
      } else {
        _currentLanguage = AppLanguage.english;
        _currentLocale = AppLanguage.english.locale;
      }
    } catch (_) {
      // Graceful fallback to English if storage encounters unexpected error
      _currentLanguage = AppLanguage.english;
      _currentLocale = AppLanguage.english.locale;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Alias for [init] to support test conventions and bootstrap hooks.
  Future<void> loadSavedLanguage() => init();

  /// Changes application language at runtime and persists to storage.
  ///
  /// Immediately notifies listeners to rebuild the application UI in the new language.
  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;

    _currentLanguage = language;
    _currentLocale = language.locale;

    try {
      if (_storageService != null) {
        await _storageService.setString(storageKey, language.code);
        await _storageService.setString(legacyStorageKey, language.code);
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(storageKey, language.code);
        await prefs.setString(legacyStorageKey, language.code);
      } catch (_) {}
    } catch (_) {
      // Keep in-memory state updated even if storage write fails
    }

    notifyListeners();
  }

  /// Changes application language using a Flutter [Locale].
  Future<void> setLocale(Locale locale) async {
    final language = AppLanguage.fromLocale(locale);
    await setLanguage(language);
  }
}
