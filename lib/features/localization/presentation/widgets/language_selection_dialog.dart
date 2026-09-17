import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/widgets/app_card.dart';

/// Interactive modal dialog for selecting the application language.
///
/// Clearly displays language names in their native scripts:
/// - English
/// - हिन्दी
/// - मराठी
class LanguageSelectionDialog extends StatelessWidget {
  final LocalizationService? localizationService;

  const LanguageSelectionDialog({
    super.key,
    this.localizationService,
  });

  /// Displays the language selection dialog modally.
  static Future<void> show(
    BuildContext context, {
    LocalizationService? localizationService,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => LanguageSelectionDialog(
        localizationService: localizationService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = localizationService ?? ServiceLocator.instance.localizationService;
    final l10n = context.l10n;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final currentLang = service.currentLanguage;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusLg,
          ),
          title: Row(
            children: [
              const Icon(Icons.language_rounded, color: AppColors.primary),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Text(
                  l10n.languageSelectionTitle,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.values.map((language) {
              final isSelected = currentLang == language;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  borderColor: isSelected ? AppColors.primary : null,
                  backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
                  onTap: () async {
                    await service.setLanguage(language);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            language.code.toUpperCase(),
                            style: TextStyle(
                              color: isSelected ? AppColors.white : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              language.nativeName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? AppColors.primary : null,
                              ),
                            ),
                            if (language != AppLanguage.english)
                              Text(
                                language.englishName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}
