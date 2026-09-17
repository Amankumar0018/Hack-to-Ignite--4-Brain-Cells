import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/emergency_enums.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../localization/presentation/widgets/language_switcher_button.dart';
import '../widgets/voice_emergency_input_card.dart';

/// Screen representing the specific emergency subcategory selection (Triage).
class EmergencyIntentScreen extends StatefulWidget {
  final String category;

  const EmergencyIntentScreen({
    super.key,
    required this.category,
  });

  @override
  State<EmergencyIntentScreen> createState() => _EmergencyIntentScreenState();
}

class _EmergencyIntentScreenState extends State<EmergencyIntentScreen> {
  String? _selectedOption;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  List<String> _getOptions(BuildContext context) {
    final lang = context.l10n.language;
    final cat = EmergencyCategory.fromString(widget.category);

    switch (cat) {
      case EmergencyCategory.medical:
        switch (lang) {
          case AppLanguage.hindi:
            return ['एम्बुलेंस', 'चोट / दुर्घटना', 'बेहोश व्यक्ति', 'अन्य'];
          case AppLanguage.marathi:
            return ['रुग्णवाहिका', 'दुखापत / अपघात', 'बेशुद्ध व्यक्ती', 'इतर'];
          case AppLanguage.english:
            return ['Ambulance', 'Injury', 'Unconscious Person', 'Other'];
        }
      case EmergencyCategory.womenSafety:
        switch (lang) {
          case AppLanguage.hindi:
            return ['असुरक्षित स्थिति', 'उत्पीड़न', 'खतरा', 'तत्काल सहायता की आवश्यकता', 'अन्य'];
          case AppLanguage.marathi:
            return ['असुरक्षित परिस्थिती', 'छळ', 'धोका', 'त्वरित मदतीची गरज', 'इतर'];
          case AppLanguage.english:
            return ['Unsafe Situation', 'Harassment', 'Threat', 'Need Immediate Assistance', 'Other'];
        }
      case EmergencyCategory.disaster:
        switch (lang) {
          case AppLanguage.hindi:
            return ['आग', 'बाढ़', 'भूकंप', 'इमारत आपातकाल', 'अन्य'];
          case AppLanguage.marathi:
            return ['आग', 'पूर', 'भूकंप', 'इमारत आणीबाणी', 'इतर'];
          case AppLanguage.english:
            return ['Fire', 'Flood', 'Earthquake', 'Building Emergency', 'Other'];
        }
      case EmergencyCategory.campus:
        switch (lang) {
          case AppLanguage.hindi:
            return ['चिकित्सा घटना', 'परिसर सुरक्षा', 'सक्रिय आग', 'उत्पीड़न / खतरा', 'अन्य'];
          case AppLanguage.marathi:
            return ['वैद्यकीय घटना', 'कॅम्पस सुरक्षा', 'सक्रिय आग', 'छळ / धोका', 'इतर'];
          case AppLanguage.english:
            return ['Medical Incident', 'Campus Security', 'Active Fire', 'Harassment/Threat', 'Other'];
        }
    }
  }

  Color _getCategoryColor() {
    final cat = EmergencyCategory.fromString(widget.category);
    switch (cat) {
      case EmergencyCategory.medical:
        return AppColors.medicalEmergency;
      case EmergencyCategory.womenSafety:
        return AppColors.womenSafety;
      case EmergencyCategory.disaster:
        return AppColors.disasterManagement;
      case EmergencyCategory.campus:
        return AppColors.campusEmergency;
    }
  }

  void _confirmEmergencyRequest() async {
    if (_selectedOption == null) return;

    final emergencyCategory = EmergencyCategory.fromString(widget.category);

    // Dispatch incident through the Emergency Engine Foundation service
    final result = await ServiceLocator.instance.emergencyService.createIncident(
      category: emergencyCategory,
      intent: _selectedOption!,
      priority: EmergencyPriority.high,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    if (result.isSuccess && result.data != null && mounted) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.emergencyTracking,
        arguments: result.data!,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Failed to broadcast emergency.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final cat = EmergencyCategory.fromString(widget.category);
    final color = _getCategoryColor();
    final options = _getOptions(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(cat.localizedName(context)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spaceSm),
              Text(
                l10n.specifyEmergencyIntent,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(
                l10n.specifyEmergencyIntentSubtitle,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              VoiceEmergencyInputCard(
                controller: _notesController,
                hintText: l10n.voiceInputHint,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.spaceSm),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = _selectedOption == option;

                    return AppCard(
                      borderColor: isSelected ? color : null,
                      backgroundColor: isSelected ? color.withValues(alpha: 0.08) : null,
                      onTap: () {
                        setState(() {
                          _selectedOption = option;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? color : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: AppDimensions.spaceMd),
                          Text(
                            option,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? color : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                backgroundColor: color,
                label: l10n.confirmEmergencyRequest,
                onPressed: _selectedOption == null ? null : _confirmEmergencyRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

