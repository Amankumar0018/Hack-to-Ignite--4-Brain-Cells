import 'dart:async';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Discrete status states for speech recognition lifecycle.
enum SpeechRecognitionStatus {
  uninitialized,
  idle,
  listening,
  stopped,
  unavailable,
  permissionDenied,
  error,
}

/// Abstract contract for device speech-to-text service.
///
/// Designed to enable citizens to describe an emergency using voice.
/// Audio is processed purely on-device into text; no raw audio is stored or transmitted.
abstract class SpeechService {
  /// Whether recognition is currently listening for voice input.
  bool get isListening;

  /// Whether speech recognition capability is available on this device.
  bool get isAvailable;

  /// Current recognition status.
  SpeechRecognitionStatus get status;

  /// Latest recognized text transcript.
  String get recognizedText;

  /// Last error message, if any.
  String? get lastError;

  /// Stream of recognized text as words are transcribed.
  Stream<String> get textStream;

  /// Stream of status changes for reactive UI updates.
  Stream<SpeechRecognitionStatus> get statusStream;

  /// Initializes the underlying speech engine and requests necessary permissions.
  ///
  /// Returns `true` if speech recognition is available and permission was granted.
  Future<bool> initialize();

  /// Starts listening for speech input.
  ///
  /// An optional [localeId] can be provided (defaults to device/English).
  /// [onResult] callback is triggered as recognized text updates.
  Future<bool> startListening({
    String? localeId,
    void Function(String text)? onResult,
  });

  /// Stops listening and finalizes recognized text.
  Future<void> stopListening();

  /// Cancels listening and discards current recognition session.
  Future<void> cancelListening();

  /// Releases resources and closes active streams.
  void dispose();
}

/// Production implementation of [SpeechService] using the `speech_to_text` package.
class SpeechToTextService implements SpeechService {
  final stt.SpeechToText _speechToText;

  final StreamController<String> _textController = StreamController<String>.broadcast();
  final StreamController<SpeechRecognitionStatus> _statusController =
      StreamController<SpeechRecognitionStatus>.broadcast();

  SpeechRecognitionStatus _status = SpeechRecognitionStatus.uninitialized;
  String _recognizedText = '';
  String? _lastError;
  bool _isAvailable = false;
  bool _isInitialized = false;

  SpeechToTextService({stt.SpeechToText? customSpeechToText})
      : _speechToText = customSpeechToText ?? stt.SpeechToText();

  @override
  bool get isListening => _speechToText.isListening;

  @override
  bool get isAvailable => _isAvailable;

  @override
  SpeechRecognitionStatus get status => _status;

  @override
  String get recognizedText => _recognizedText;

  @override
  String? get lastError => _lastError;

  @override
  Stream<String> get textStream => _textController.stream;

  @override
  Stream<SpeechRecognitionStatus> get statusStream => _statusController.stream;

  void _updateStatus(SpeechRecognitionStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      if (!_statusController.isClosed) {
        _statusController.add(newStatus);
      }
    }
  }

  @override
  Future<bool> initialize() async {
    if (_isInitialized && _isAvailable) {
      return true;
    }

    try {
      _lastError = null;
      _isAvailable = await _speechToText.initialize(
        onStatus: (sttStatus) {
          if (sttStatus == 'listening') {
            _updateStatus(SpeechRecognitionStatus.listening);
          } else if (sttStatus == 'notListening' || sttStatus == 'done') {
            if (_status == SpeechRecognitionStatus.listening) {
              _updateStatus(SpeechRecognitionStatus.stopped);
            }
          }
        },
        onError: (SpeechRecognitionError error) {
          _handleError(error.errorMsg, isPermanent: error.permanent);
        },
      );

      _isInitialized = true;

      if (_isAvailable) {
        _updateStatus(SpeechRecognitionStatus.idle);
        return true;
      } else {
        final hasPerm = await _speechToText.hasPermission;
        if (!hasPerm) {
          _lastError = 'Microphone permission denied';
          _updateStatus(SpeechRecognitionStatus.permissionDenied);
        } else {
          _lastError = 'Speech recognition unavailable on this device';
          _updateStatus(SpeechRecognitionStatus.unavailable);
        }
        return false;
      }
    } catch (e) {
      _lastError = 'Initialization failed: $e';
      _isAvailable = false;
      _updateStatus(SpeechRecognitionStatus.error);
      return false;
    }
  }

  void _handleError(String errorMsg, {bool isPermanent = false}) {
    _lastError = errorMsg;
    final lower = errorMsg.toLowerCase();
    if (lower.contains('permission') || lower.contains('denied')) {
      _updateStatus(SpeechRecognitionStatus.permissionDenied);
    } else if (lower.contains('not available') || lower.contains('unavailable')) {
      _updateStatus(SpeechRecognitionStatus.unavailable);
    } else {
      _updateStatus(SpeechRecognitionStatus.error);
    }
  }

  @override
  Future<bool> startListening({
    String? localeId,
    void Function(String text)? onResult,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        return false;
      }
    }

    if (!_isAvailable) {
      _updateStatus(SpeechRecognitionStatus.unavailable);
      return false;
    }

    try {
      _lastError = null;
      _recognizedText = '';
      _updateStatus(SpeechRecognitionStatus.listening);

      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          _recognizedText = result.recognizedWords;
          if (!_textController.isClosed) {
            _textController.add(_recognizedText);
          }
          if (onResult != null) {
            onResult(_recognizedText);
          }
          if (result.finalResult) {
            _updateStatus(SpeechRecognitionStatus.stopped);
          }
        },
        listenOptions: stt.SpeechListenOptions(
          cancelOnError: true,
          partialResults: true,
          listenMode: stt.ListenMode.confirmation,
          localeId: localeId,
        ),
      );

      return true;
    } catch (e) {
      // Graceful fallback: If listening with specific locale fails, attempt without locale constraint
      if (localeId != null) {
        try {
          await _speechToText.listen(
            onResult: (SpeechRecognitionResult result) {
              _recognizedText = result.recognizedWords;
              if (!_textController.isClosed) {
                _textController.add(_recognizedText);
              }
              if (onResult != null) {
                onResult(_recognizedText);
              }
              if (result.finalResult) {
                _updateStatus(SpeechRecognitionStatus.stopped);
              }
            },
            listenOptions: stt.SpeechListenOptions(
              cancelOnError: true,
              partialResults: true,
              listenMode: stt.ListenMode.confirmation,
            ),
          );
          return true;
        } catch (_) {}
      }

      _lastError = 'Failed to start listening: $e';
      _updateStatus(SpeechRecognitionStatus.error);
      return false;
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }
      _updateStatus(SpeechRecognitionStatus.stopped);
    } catch (e) {
      _lastError = 'Failed to stop listening: $e';
      _updateStatus(SpeechRecognitionStatus.error);
    }
  }

  @override
  Future<void> cancelListening() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.cancel();
      }
      _updateStatus(SpeechRecognitionStatus.idle);
    } catch (e) {
      _lastError = 'Failed to cancel listening: $e';
      _updateStatus(SpeechRecognitionStatus.error);
    }
  }

  @override
  void dispose() {
    _textController.close();
    _statusController.close();
  }
}

/// Controllable mock implementation of [SpeechService] for automated testing.
class MockSpeechService implements SpeechService {
  final StreamController<String> _textController = StreamController<String>.broadcast();
  final StreamController<SpeechRecognitionStatus> _statusController =
      StreamController<SpeechRecognitionStatus>.broadcast();

  SpeechRecognitionStatus _status = SpeechRecognitionStatus.idle;
  String _recognizedText = '';
  String? _lastError;
  bool _isListening = false;
  final bool _isAvailable = true;

  /// Test hooks to simulate conditions
  bool mockShouldFailInit = false;
  bool mockPermissionDenied = false;
  bool mockUnavailable = false;
  String? mockRecognizedWordsToEmit;
  String? lastLocaleId;
  Set<String>? mockSupportedLocales;

  @override
  bool get isListening => _isListening;

  @override
  bool get isAvailable => _isAvailable && !mockUnavailable && !mockPermissionDenied;

  @override
  SpeechRecognitionStatus get status => _status;

  @override
  String get recognizedText => _recognizedText;

  @override
  String? get lastError => _lastError;

  @override
  Stream<String> get textStream => _textController.stream;

  @override
  Stream<SpeechRecognitionStatus> get statusStream => _statusController.stream;

  void setStatus(SpeechRecognitionStatus newStatus) {
    _status = newStatus;
    _isListening = newStatus == SpeechRecognitionStatus.listening;
    if (!_statusController.isClosed) {
      _statusController.add(newStatus);
    }
  }

  void emitRecognizedText(String text) {
    _recognizedText = text;
    if (!_textController.isClosed) {
      _textController.add(text);
    }
  }

  @override
  Future<bool> initialize() async {
    if (mockShouldFailInit) {
      _lastError = 'Mock initialization error';
      setStatus(SpeechRecognitionStatus.error);
      return false;
    }
    if (mockPermissionDenied) {
      _lastError = 'Microphone permission denied';
      setStatus(SpeechRecognitionStatus.permissionDenied);
      return false;
    }
    if (mockUnavailable) {
      _lastError = 'Speech recognition unavailable';
      setStatus(SpeechRecognitionStatus.unavailable);
      return false;
    }

    _lastError = null;
    setStatus(SpeechRecognitionStatus.idle);
    return true;
  }

  @override
  Future<bool> startListening({
    String? localeId,
    void Function(String text)? onResult,
  }) async {
    if (mockPermissionDenied) {
      _lastError = 'Microphone permission denied';
      setStatus(SpeechRecognitionStatus.permissionDenied);
      return false;
    }
    if (mockUnavailable) {
      _lastError = 'Speech recognition unavailable';
      setStatus(SpeechRecognitionStatus.unavailable);
      return false;
    }
    if (mockShouldFailInit) {
      _lastError = 'Mock error starting recognition';
      setStatus(SpeechRecognitionStatus.error);
      return false;
    }

    _lastError = null;
    _isListening = true;
    lastLocaleId = localeId;
    if (mockSupportedLocales != null && localeId != null && !mockSupportedLocales!.contains(localeId)) {
      lastLocaleId = 'en_IN'; // Graceful engine fallback
    }
    setStatus(SpeechRecognitionStatus.listening);

    if (mockRecognizedWordsToEmit != null) {
      _recognizedText = mockRecognizedWordsToEmit!;
      emitRecognizedText(_recognizedText);
      if (onResult != null) {
        onResult(_recognizedText);
      }
    }

    return true;
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    setStatus(SpeechRecognitionStatus.stopped);
  }

  @override
  Future<void> cancelListening() async {
    _isListening = false;
    _recognizedText = '';
    setStatus(SpeechRecognitionStatus.idle);
  }

  @override
  void dispose() {
    _textController.close();
    _statusController.close();
  }
}
