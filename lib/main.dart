import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_strings.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/localization_service.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/service_locator.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage
  final prefs = await SharedPreferences.getInstance();

  // Initialize service locator foundation
  ServiceLocator.instance.init(
    customStorageService: SharedPreferencesStorageService(prefs),
    customSecureStorageService: FlutterSecureStorageService(),
    useBackendApi: true,
  );

  // Restore saved language preference on app startup
  await ServiceLocator.instance.localizationService.init();

  runApp(const PukaarApp());
}

/// Root widget for the Pukaar Emergency Platform.
class PukaarApp extends StatelessWidget {
  const PukaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationService = ServiceLocator.instance.localizationService;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          locale: localizationService.currentLocale,
          supportedLocales: LocalizationService.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
