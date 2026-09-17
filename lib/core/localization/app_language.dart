import 'package:flutter/material.dart';

/// Supported application languages for Pukaar multilingual localization.
enum AppLanguage {
  english(
    code: 'en',
    nativeName: 'English',
    englishName: 'English',
    speechLocale: 'en_IN',
  ),
  hindi(
    code: 'hi',
    nativeName: 'हिन्दी',
    englishName: 'Hindi',
    speechLocale: 'hi_IN',
  ),
  marathi(
    code: 'mr',
    nativeName: 'मराठी',
    englishName: 'Marathi',
    speechLocale: 'mr_IN',
  );

  final String code;
  final String nativeName;
  final String englishName;
  final String speechLocale;

  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.speechLocale,
  });

  /// Flutter [Locale] representation for this language.
  Locale get locale => Locale(code);

  /// All supported application locales.
  static List<Locale> get supportedLocales =>
      AppLanguage.values.map((lang) => lang.locale).toList();

  /// Resolves [AppLanguage] from language code string. Defaults to [AppLanguage.english].
  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.english;
    final normalized = code.toLowerCase().trim();
    for (final lang in AppLanguage.values) {
      if (lang.code == normalized) {
        return lang;
      }
    }
    return AppLanguage.english;
  }

  /// Resolves [AppLanguage] from Flutter [Locale].
  static AppLanguage fromLocale(Locale locale) {
    return fromCode(locale.languageCode);
  }
}
