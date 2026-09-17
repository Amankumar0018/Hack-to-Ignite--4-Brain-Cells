import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/widgets/app_card.dart';

/// Full screen view for language selection.
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationService = ServiceLocator.instance.localizationService;
    final l10n = context.l10n;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, _) {
        final currentLang = localizationService.currentLanguage;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.languageSelectionTitle),
          ),
          body: SafeArea(
            child: ListView(
              padding: AppDimensions.paddingMd,
              children: AppLanguage.values.map((language) {
                final isSelected = currentLang == language;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                  child: AppCard(
                    padding: AppDimensions.paddingMd,
                    borderColor: isSelected ? AppColors.primary : null,
                    backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
                    onTap: () async {
                      await localizationService.setLanguage(language);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
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
                                fontSize: 13,
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
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
