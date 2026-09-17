import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../localization/presentation/widgets/language_selection_dialog.dart';
import '../../../localization/presentation/widgets/language_switcher_button.dart';

/// User Profile and configuration settings screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;

  bool _locationEnabled = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _loadProfileData() async {
    final authService = ServiceLocator.instance.authService;
    final locationService = ServiceLocator.instance.locationService;

    final profile = await authService.getCurrentUser();
    final gpsEnabled = await locationService.isLocationServiceEnabled();

    if (profile != null) {
      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _emailController.text = profile.email ?? '';
        _ageController.text = profile.age?.toString() ?? '';
        _locationEnabled = gpsEnabled;
        _isLoading = false;
      });
    } else {
      setState(() {
        _locationEnabled = gpsEnabled;
        _isLoading = false;
      });
    }
  }

  void _saveProfileChanges() async {
    if (_profile == null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final updated = _profile!.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      age: _ageController.text.trim().isEmpty ? null : int.tryParse(_ageController.text.trim()),
    );

    final authService = ServiceLocator.instance.authService;
    await authService.updateCurrentUser(updated);

    setState(() {
      _profile = updated;
      _isSaving = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _handleLogout() async {
    final authService = ServiceLocator.instance.authService;
    await authService.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profile)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profile)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.noDataFound),
              const SizedBox(height: 16),
              SecondaryButton(
                label: l10n.signIn,
                onPressed: _handleLogout,
                isFullWidth: false,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.paddingMd,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Avatar & Role Header
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.secondary,
                        child: Icon(Icons.person, size: 48, color: AppColors.white),
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      Text(
                        _profile!.name,
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppDimensions.space2xs),
                      Text(
                        _profile!.mobileNumber,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppDimensions.spaceXs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _profile!.isDual
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : _profile!.isResponder
                                  ? AppColors.warning.withValues(alpha: 0.15)
                                  : AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _profile!.isDual
                              ? l10n.dualRole
                              : _profile!.isResponder
                                  ? l10n.responderRole
                                  : l10n.citizenRole,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _profile!.isDual
                                ? AppColors.primary
                                : _profile!.isResponder
                                    ? AppColors.warning
                                    : AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),

                // Edit Personal details Card
                Text(
                  l10n.editPersonalInformation,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                AppCard(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.fullName,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              decoration: InputDecoration(
                                labelText: l10n.ageYears,
                                prefixIcon: const Icon(Icons.cake_outlined),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceSm),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: l10n.emailOptional,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      PrimaryButton(
                        label: l10n.save,
                        isLoading: _isSaving,
                        onPressed: _saveProfileChanges,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),

                // Emergency shortcuts & Preferences Card
                Text(
                  l10n.emergencyConfigurations,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                        title: Text(l10n.appLanguageLabel),
                        subtitle: Text(
                          '${ServiceLocator.instance.localizationService.currentLanguage.nativeName} (${ServiceLocator.instance.localizationService.currentLanguage.englishName})',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => const LanguageSelectionDialog(),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.contacts_rounded, color: AppColors.secondaryLight),
                        title: Text(l10n.emergencyContacts),
                        subtitle: Text('Primary: ${_profile!.emergencyContactName}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.emergencyContacts).then((_) {
                          _loadProfileData();
                        }),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.medical_information_rounded, color: AppColors.medicalEmergency),
                        title: Text(l10n.medicalId),
                        subtitle: Text('Blood type: ${_profile!.bloodGroup ?? "Not set"}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.medicalId).then((_) {
                          _loadProfileData();
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),

                // Status Toggles Card
                Text(
                  l10n.systemPermissionsAndStatus,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.location_on, color: AppColors.success),
                        title: Text(l10n.locationServicesStatus),
                        subtitle: Text(_locationEnabled ? 'Permission Enabled' : 'Disabled / Missing Permission'),
                        trailing: Icon(
                          _locationEnabled ? Icons.check_circle : Icons.warning,
                          color: _locationEnabled ? Colors.green : Colors.amber,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.notifications_active_outlined, color: AppColors.accent),
                        title: Text(l10n.emergencyBroadcastAlerts),
                        subtitle: const Text('Campus & regional disaster notices'),
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: (val) {
                            setState(() {
                              _notificationsEnabled = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space2xl),

                SecondaryButton(
                  label: l10n.signOut,
                  onPressed: _handleLogout,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
