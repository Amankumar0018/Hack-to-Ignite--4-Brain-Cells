import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/speech_service.dart';
import '../../../../shared/widgets/app_card.dart';

/// Reusable Voice Emergency Input Card allowing citizens to describe an emergency
/// using speech-to-text or normal keyboard typing.
///
/// Features:
/// - Real-time device speech-to-text transcription
/// - Fully editable text field for immediate citizen corrections
/// - Non-blocking typing fallback
/// - Graceful error and permission state handling with retry action
/// - Clean subscription cancellation on widget disposal
class VoiceEmergencyInputCard extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onTextChanged;
  final SpeechService? speechService;
  final String? hintText;

  const VoiceEmergencyInputCard({
    super.key,
    this.controller,
    this.onTextChanged,
    this.speechService,
    this.hintText,
  });

  @override
  State<VoiceEmergencyInputCard> createState() => _VoiceEmergencyInputCardState();
}

class _VoiceEmergencyInputCardState extends State<VoiceEmergencyInputCard>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final bool _ownsController;
  late final SpeechService _speechService;

  StreamSubscription<String>? _textSubscription;
  StreamSubscription<SpeechRecognitionStatus>? _statusSubscription;

  SpeechRecognitionStatus _status = SpeechRecognitionStatus.idle;
  String? _errorMessage;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _speechService = widget.speechService ?? ServiceLocator.instance.speechService;

    _status = _speechService.status;
    _errorMessage = _speechService.lastError;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Subscribe to status and recognized text streams
    _statusSubscription = _speechService.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _status = status;
          if (status == SpeechRecognitionStatus.listening) {
            _pulseController.repeat(reverse: true);
          } else {
            _pulseController.stop();
            _pulseController.reset();
          }

          if (status == SpeechRecognitionStatus.error ||
              status == SpeechRecognitionStatus.permissionDenied ||
              status == SpeechRecognitionStatus.unavailable) {
            _errorMessage = _speechService.lastError ?? _getDefaultErrorMessage(status);
          } else {
            _errorMessage = null;
          }
        });
      }
    });

    _textSubscription = _speechService.textStream.listen((text) {
      if (mounted && text.isNotEmpty) {
        setState(() {
          _controller.text = text;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
        widget.onTextChanged?.call(text);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textSubscription?.cancel();
    _statusSubscription?.cancel();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  String _getDefaultErrorMessage(SpeechRecognitionStatus status) {
    final l10n = AppLocalizations.ofLocale(ServiceLocator.instance.localizationService.currentLocale);
    switch (status) {
      case SpeechRecognitionStatus.permissionDenied:
        return l10n.micPermissionDenied;
      case SpeechRecognitionStatus.unavailable:
        return l10n.speechUnavailable;
      case SpeechRecognitionStatus.error:
        return l10n.speechError;
      default:
        return l10n.speechError;
    }
  }

  Future<void> _toggleListening() async {
    if (_speechService.isListening || _status == SpeechRecognitionStatus.listening) {
      await _speechService.stopListening();
    } else {
      setState(() {
        _errorMessage = null;
      });
      final speechLocale = ServiceLocator.instance.localizationService.currentSpeechLocale;
      final success = await _speechService.startListening(
        localeId: speechLocale,
        onResult: (text) {
          if (mounted && text.isNotEmpty) {
            setState(() {
              _controller.text = text;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
            });
            widget.onTextChanged?.call(text);
          }
        },
      );

      if (!success && mounted) {
        setState(() {
          _status = _speechService.status;
          _errorMessage = _speechService.lastError ?? _getDefaultErrorMessage(_status);
        });
      }
    }
  }

  Future<void> _cancelListening() async {
    await _speechService.cancelListening();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isListening = _status == SpeechRecognitionStatus.listening || _speechService.isListening;
    final hasError = _errorMessage != null &&
        (_status == SpeechRecognitionStatus.error ||
            _status == SpeechRecognitionStatus.permissionDenied ||
            _status == SpeechRecognitionStatus.unavailable);

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      borderColor: isListening
          ? AppColors.primary
          : (hasError ? AppColors.warning.withValues(alpha: 0.4) : null),
      backgroundColor: isListening
          ? AppColors.primary.withValues(alpha: 0.04)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row: Voice prompt and Mic action button
          Row(
            children: [
              // Microphone button with pulse effect when listening
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isListening ? _pulseAnimation.value : 1.0,
                    child: child,
                  );
                },
                child: Material(
                  color: isListening ? AppColors.primary : theme.colorScheme.primaryContainer,
                  shape: const CircleBorder(),
                  elevation: isListening ? 4 : 0,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _toggleListening,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none_rounded,
                        color: isListening ? Colors.white : theme.colorScheme.primary,
                        size: 26,
                      ),
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
                      isListening
                          ? l10n.listeningSpeakNow
                          : (_controller.text.isNotEmpty
                              ? l10n.voiceInputRecorded
                              : l10n.describeEmergencyByVoice),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isListening ? AppColors.primary : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isListening
                          ? l10n.tapMicToStop
                          : (_controller.text.isNotEmpty
                              ? l10n.tapMicToSpeakAgain
                              : l10n.tapMicOrType),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isListening)
                TextButton(
                  onPressed: _cancelListening,
                  child: Text(l10n.cancel, style: const TextStyle(color: AppColors.error)),
                ),
            ],
          ),

          // Error / Permission Notice if any
          if (hasError) ...[
            const SizedBox(height: AppDimensions.spaceSm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusSm,
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _toggleListening,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(50, 30),
                    ),
                    child: Text(l10n.retry, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppDimensions.spaceSm),

          // Editable Description Field (Citizen can edit recognized words or type directly)
          TextFormField(
            controller: _controller,
            maxLines: 3,
            minLines: 2,
            onChanged: (val) {
              widget.onTextChanged?.call(val);
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: widget.hintText ?? l10n.voiceInputHint,
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.all(AppDimensions.spaceSm),
              border: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusMd,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusMd,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusMd,
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      tooltip: 'Clear text',
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                        widget.onTextChanged?.call('');
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
