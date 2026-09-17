import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../core/services/service_locator.dart';
import 'language_selection_dialog.dart';

/// Clean AppBar action button displaying current language and opening language selector.
class LanguageSwitcherButton extends StatelessWidget {
  final bool compact;
  final LocalizationService? localizationService;

  const LanguageSwitcherButton({
    super.key,
    this.compact = false,
    this.localizationService,
  });

  @override
  Widget build(BuildContext context) {
    final service = localizationService ?? ServiceLocator.instance.localizationService;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final currentLang = service.currentLanguage;

        if (compact) {
          return IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: 'Change Language / भाषा बदलें',
            onPressed: () => LanguageSelectionDialog.show(
              context,
              localizationService: service,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: InkWell(
            onTap: () => LanguageSelectionDialog.show(
              context,
              localizationService: service,
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.space2xs),
                  Text(
                    currentLang.nativeName,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
