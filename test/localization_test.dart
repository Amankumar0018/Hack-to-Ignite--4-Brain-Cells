import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pukaar/core/localization/app_language.dart';
import 'package:pukaar/core/localization/app_localizations.dart';
import 'package:pukaar/core/localization/localization_service.dart';
import 'package:pukaar/core/models/emergency_enums.dart';
import 'package:pukaar/features/localization/presentation/widgets/language_selection_dialog.dart';
import 'package:pukaar/features/localization/presentation/widgets/language_switcher_button.dart';

void main() {
  group('AppLanguage and Models', () {
    test('AppLanguage enum values and metadata', () {
      expect(AppLanguage.english.code, 'en');
      expect(AppLanguage.english.nativeName, 'English');
      expect(AppLanguage.english.englishName, 'English');
      expect(AppLanguage.english.locale, const Locale('en'));

      expect(AppLanguage.hindi.code, 'hi');
      expect(AppLanguage.hindi.nativeName, 'हिन्दी');
      expect(AppLanguage.hindi.englishName, 'Hindi');
      expect(AppLanguage.hindi.locale, const Locale('hi'));

      expect(AppLanguage.marathi.code, 'mr');
      expect(AppLanguage.marathi.nativeName, 'मराठी');
      expect(AppLanguage.marathi.englishName, 'Marathi');
      expect(AppLanguage.marathi.locale, const Locale('mr'));
    });

    test('AppLanguage.fromCode resolution with fallback', () {
      expect(AppLanguage.fromCode('en'), AppLanguage.english);
      expect(AppLanguage.fromCode('hi'), AppLanguage.hindi);
      expect(AppLanguage.fromCode('mr'), AppLanguage.marathi);
      expect(AppLanguage.fromCode('fr'), AppLanguage.english);
      expect(AppLanguage.fromCode(null), AppLanguage.english);
    });

    test('AppLanguage.fromLocale resolution', () {
      expect(AppLanguage.fromLocale(const Locale('en')), AppLanguage.english);
      expect(AppLanguage.fromLocale(const Locale('hi')), AppLanguage.hindi);
      expect(AppLanguage.fromLocale(const Locale('mr')), AppLanguage.marathi);
      expect(AppLanguage.fromLocale(const Locale('de')), AppLanguage.english);
    });
  });

  group('AppLocalizations Strings Coverage', () {
    test('English translations have expected values', () {
      final en = AppLocalizations(AppLanguage.english);
      expect(en.appName, 'Pukaar');
      expect(en.medicalEmergency, 'Medical Emergency');
      expect(en.womenSafety, "Women's Safety");
      expect(en.disasterManagement, 'Disaster Management');
      expect(en.campusEmergency, 'Campus Emergency');
      expect(en.triggerSos, 'TRIGGER SOS');
      expect(en.cancelSos, 'Cancel SOS');
      expect(en.cancelEmergency, 'Cancel Emergency');
      expect(en.createAccount, 'Create Account');
      expect(en.createPukaarProfile, 'Create Pukaar Profile');
      expect(en.statusCreated, 'Incident Created');
      expect(en.aiIncidentIntelligence, 'AI INCIDENT INTELLIGENCE');
      expect(en.aiAdvisoryDisclaimer, 'AI Advisory — Verify before action');
    });

    test('Hindi translations have expected values', () {
      final hi = AppLocalizations(AppLanguage.hindi);
      expect(hi.appName, 'Pukaar');
      expect(hi.medicalEmergency, 'चिकित्सा आपातकाल');
      expect(hi.womenSafety, 'महिला सुरक्षा');
      expect(hi.disasterManagement, 'आपदा प्रबंधन');
      expect(hi.campusEmergency, 'परिसर आपातकाल');
      expect(hi.triggerSos, 'एसओएस ट्रिगर करें');
      expect(hi.cancelSos, 'एसओएस रद्द करें');
      expect(hi.cancelEmergency, 'आपातकाल रद्द करें');
      expect(hi.createPukaarProfile, 'पुकार प्रोफ़ाइल बनाएं');
      expect(hi.statusCreated, 'घटना दर्ज की गई');
      expect(hi.aiIncidentIntelligence, 'एआई घटना विश्लेषण');
      expect(hi.aiAdvisoryDisclaimer, 'एआई सलाह — कार्रवाई से पहले सत्यापन करें');
    });

    test('Marathi translations have expected values', () {
      final mr = AppLocalizations(AppLanguage.marathi);
      expect(mr.appName, 'Pukaar');
      expect(mr.medicalEmergency, 'वैद्यकीय आणीबाणी');
      expect(mr.womenSafety, 'महिला सुरक्षा');
      expect(mr.disasterManagement, 'आपत्ती व्यवस्थापन');
      expect(mr.campusEmergency, 'कॅम्पस आणीबाणी');
      expect(mr.triggerSos, 'एसओएस सुरू करा');
      expect(mr.cancelSos, 'एसओएस रद्द करा');
      expect(mr.cancelEmergency, 'आणीबाणी रद्द करा');
      expect(mr.createPukaarProfile, 'पुकार प्रोफाइल तयार करा');
      expect(mr.statusCreated, 'घटना नोंदवली गेली');
      expect(mr.aiIncidentIntelligence, 'एआय घटना बुद्धिमत्ता');
      expect(mr.aiAdvisoryDisclaimer, 'एआय सल्ला — कारवाईपूर्वी खात्री करा');
    });

    test('Parametric methods format properly', () {
      final en = AppLocalizations(AppLanguage.english);
      final hi = AppLocalizations(AppLanguage.hindi);
      final mr = AppLocalizations(AppLanguage.marathi);

      expect(en.resendInSeconds(30), 'Resend in 30s');
      expect(hi.resendInSeconds(30), '30 सेकंड में पुनः भेजें');
      expect(mr.resendInSeconds(30), '30 सेकंदात पुन्हा पाठवा');
    });
  });

  group('Emergency Category & Status Multilingual Resolution', () {
    test('EmergencyCategory.fromString parses English, Hindi, and Marathi inputs', () {
      // English
      expect(EmergencyCategory.fromString('Medical Emergency'), EmergencyCategory.medical);
      expect(EmergencyCategory.fromString('Women\'s Safety'), EmergencyCategory.womenSafety);
      expect(EmergencyCategory.fromString('Disaster Management'), EmergencyCategory.disaster);
      expect(EmergencyCategory.fromString('Campus Emergency'), EmergencyCategory.campus);

      // Hindi
      expect(EmergencyCategory.fromString('चिकित्सा आपातकाल'), EmergencyCategory.medical);
      expect(EmergencyCategory.fromString('महिला सुरक्षा'), EmergencyCategory.womenSafety);
      expect(EmergencyCategory.fromString('आपदा प्रबंधन'), EmergencyCategory.disaster);
      expect(EmergencyCategory.fromString('परिसर आपातकाल'), EmergencyCategory.campus);

      // Marathi
      expect(EmergencyCategory.fromString('वैद्यकीय आणीबाणी'), EmergencyCategory.medical);
      expect(EmergencyCategory.fromString('आपत्ती व्यवस्थापन'), EmergencyCategory.disaster);
      expect(EmergencyCategory.fromString('कॅम्पस आणीबाणी'), EmergencyCategory.campus);
    });
  });

  group('LocalizationService Persistence', () {
    test('loadSavedLanguage loads correctly from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'app_language_code': 'hi'});
      final service = LocalizationService();
      await service.loadSavedLanguage();

      expect(service.currentLanguage, AppLanguage.hindi);
      expect(service.currentLocale, const Locale('hi'));
    });

    test('setLanguage updates state, notifies listeners, and persists to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final service = LocalizationService();
      await service.loadSavedLanguage();
      expect(service.currentLanguage, AppLanguage.english);

      bool listenerFired = false;
      service.addListener(() {
        listenerFired = true;
      });

      await service.setLanguage(AppLanguage.marathi);
      expect(service.currentLanguage, AppLanguage.marathi);
      expect(service.currentLocale, const Locale('mr'));
      expect(listenerFired, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_language_code'), 'mr');
    });
  });

  group('Widget Tests: Language Switching & Reactive UI', () {
    testWidgets('LanguageSelectionDialog displays all 3 languages and allows selection', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final service = LocalizationService();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLanguage.supportedLocales,
          locale: service.currentLocale,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => LanguageSelectionDialog(
                        localizationService: service,
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify all 3 language choices appear in the dialog
      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('हिन्दी'), findsOneWidget);
      expect(find.text('मराठी'), findsOneWidget);

      // Select Hindi
      await tester.tap(find.text('हिन्दी'));
      await tester.pumpAndSettle();

      expect(service.currentLanguage, AppLanguage.hindi);
    });

    testWidgets('LanguageSwitcherButton opens dialog and changing language updates UI instantly', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final service = LocalizationService();

      await tester.pumpWidget(
        AnimatedBuilder(
          animation: service,
          builder: (context, _) {
            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLanguage.supportedLocales,
              locale: service.currentLocale,
              home: Scaffold(
                appBar: AppBar(
                  title: Builder(
                    builder: (ctx) => Text(AppLocalizations.of(ctx).medicalEmergency),
                  ),
                  actions: [
                    LanguageSwitcherButton(
                      localizationService: service,
                      compact: true,
                    ),
                  ],
                ),
                body: Builder(
                  builder: (ctx) {
                    final l10n = AppLocalizations.of(ctx);
                    return Center(child: Text(l10n.immediateEmergencyBroadcast));
                  },
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Initial state: English
      expect(find.text('Medical Emergency'), findsOneWidget);
      expect(find.text('IMMEDIATE EMERGENCY BROADCAST'), findsOneWidget);

      // Tap language switcher button in AppBar
      await tester.tap(find.byType(LanguageSwitcherButton));
      await tester.pumpAndSettle();

      // Tap Marathi
      await tester.tap(find.text('मराठी'));
      await tester.pumpAndSettle();

      // UI should immediately rebuild in Marathi!
      expect(find.text('वैद्यकीय आणीबाणी'), findsOneWidget);
      expect(find.text('त्वरित आणीबाणी प्रसारण'), findsOneWidget);
    });
  });
}
