import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../localization/presentation/widgets/language_switcher_button.dart';

/// Onboarding screen introducing users to Pukaar's 4 core emergency pillars.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    final authService = ServiceLocator.instance.authService;
    await authService.setOnboardingCompleted(true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcomeToPukaar),
        automaticallyImplyLeading: false,
        actions: [
          const LanguageSwitcherButton(),
          if (_currentPage < 2)
            TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                l10n.skip,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildPageOne(theme, l10n),
                    _buildPageTwo(theme, l10n),
                    _buildPageThree(theme, l10n),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              // Indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 24.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      borderRadius: AppDimensions.borderRadiusFull,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                        child: SecondaryButton(
                          label: l10n.back,
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),
                  Expanded(
                    child: PrimaryButton(
                      label: _currentPage == 2 ? l10n.getStarted : l10n.continueText,
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageOne(ThemeData theme, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.shield_outlined,
          size: 100,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        Text(
          l10n.onboardingSlide1Title,
          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
          child: Text(
            l10n.onboardingSlide1Body,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPageTwo(ThemeData theme, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingSlide2Title,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              _FeaturePillar(
                icon: Icons.medical_services_rounded,
                color: AppColors.medicalEmergency,
                title: l10n.medicalEmergency,
                description: l10n.medicalEmergencyDesc,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              _FeaturePillar(
                icon: Icons.shield_rounded,
                color: AppColors.womenSafety,
                title: l10n.womenSafety,
                description: l10n.womenSafetyDesc,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              _FeaturePillar(
                icon: Icons.warning_rounded,
                color: AppColors.disasterManagement,
                title: l10n.disasterManagement,
                description: l10n.disasterManagementDesc,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              _FeaturePillar(
                icon: Icons.school_rounded,
                color: AppColors.campusEmergency,
                title: l10n.campusEmergency,
                description: l10n.campusEmergencyDesc,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageThree(ThemeData theme, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.people_alt_outlined,
          size: 100,
          color: AppColors.accent,
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        Text(
          l10n.onboardingSlide3Title,
          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
          child: Text(
            l10n.onboardingSlide3Body,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _FeaturePillar extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _FeaturePillar({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: AppDimensions.paddingSm,
      child: Row(
        children: [
          Container(
            padding: AppDimensions.paddingSm,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppDimensions.borderRadiusSm,
            ),
            child: Icon(icon, color: color, size: AppDimensions.iconMd),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
