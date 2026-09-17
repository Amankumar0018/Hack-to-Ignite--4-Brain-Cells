import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../localization/presentation/widgets/language_switcher_button.dart';

/// User registration screen collecting emergency-critical details.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final phoneArg = ModalRoute.of(context)?.settings.arguments as String?;
      if (phoneArg != null) {
        _mobileController.text = phoneArg;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final profile = UserProfile(
      name: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      age: _ageController.text.trim().isEmpty ? null : int.tryParse(_ageController.text.trim()),
      emergencyContactName: _contactNameController.text.trim(),
      emergencyContactPhone: _contactPhoneController.text.trim(),
    );

    final authService = ServiceLocator.instance.authService;
    final result = await authService.registerUser(profile);

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.completeProfile),
        actions: const [
          LanguageSwitcherButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.emergencyProfile,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                Text(
                  l10n.emergencyProfileDesc,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                if (_errorMessage != null) ...[
                  AppCard(
                    backgroundColor: theme.colorScheme.errorContainer,
                    borderColor: theme.colorScheme.error,
                    padding: AppDimensions.paddingSm,
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.personalInfo,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '${l10n.fullName} *',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          labelText: '${l10n.mobileNumber} *',
                          prefixIcon: const Icon(Icons.phone_android_rounded),
                        ),
                        keyboardType: TextInputType.phone,
                        readOnly: true, // User verified this in previous step
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
                      Text(
                        l10n.primaryEmergencyContact,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      TextFormField(
                        controller: _contactNameController,
                        decoration: InputDecoration(
                          labelText: '${l10n.contactPersonName} *',
                          prefixIcon: const Icon(Icons.contacts_outlined),
                          hintText: 'e.g. Spouse, Father, Friend',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Emergency contact name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      TextFormField(
                        controller: _contactPhoneController,
                        decoration: InputDecoration(
                          labelText: '${l10n.contactPersonMobile} *',
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().length < 10) {
                            return 'Please enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      PrimaryButton(
                        label: l10n.saveEmergencyProfile,
                        isLoading: _isLoading,
                        onPressed: _handleRegister,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
