import 'package:flutter_test/flutter_test.dart';
import 'package:pukaar/core/services/speech_service.dart';

void main() {
  group('MockSpeechService Unit Tests', () {
    late MockSpeechService speechService;

    setUp(() {
      speechService = MockSpeechService();
    });

    tearDown(() {
      speechService.dispose();
    });

    test('1. Speech service initializes successfully by default', () async {
      final initialized = await speechService.initialize();
      expect(initialized, isTrue);
      expect(speechService.isAvailable, isTrue);
      expect(speechService.status, equals(SpeechRecognitionStatus.idle));
      expect(speechService.lastError, isNull);
    });

    test('2. Start listening transitions state to listening', () async {
      await speechService.initialize();
      final started = await speechService.startListening();

      expect(started, isTrue);
      expect(speechService.isListening, isTrue);
      expect(speechService.status, equals(SpeechRecognitionStatus.listening));
    });

    test('3. Stop listening transitions state to stopped', () async {
      await speechService.initialize();
      await speechService.startListening();
      expect(speechService.isListening, isTrue);

      await speechService.stopListening();
      expect(speechService.isListening, isFalse);
      expect(speechService.status, equals(SpeechRecognitionStatus.stopped));
    });

    test('4. Cancel listening resets recognized text and sets status to idle', () async {
      await speechService.initialize();
      speechService.mockRecognizedWordsToEmit = 'Emergency near gate';
      await speechService.startListening();
      expect(speechService.recognizedText, equals('Emergency near gate'));

      await speechService.cancelListening();
      expect(speechService.isListening, isFalse);
      expect(speechService.recognizedText, isEmpty);
      expect(speechService.status, equals(SpeechRecognitionStatus.idle));
    });

    test('5. Recognized text propagation via stream and callback', () async {
      await speechService.initialize();
      String? callbackText;

      final streamedWords = <String>[];
      final subscription = speechService.textStream.listen((text) {
        streamedWords.add(text);
      });

      speechService.mockRecognizedWordsToEmit = 'Need ambulance immediately';
      await speechService.startListening(
        onResult: (text) {
          callbackText = text;
        },
      );

      // Verify callback & property
      expect(callbackText, equals('Need ambulance immediately'));
      expect(speechService.recognizedText, equals('Need ambulance immediately'));

      // Verify stream emissions
      await Future.delayed(const Duration(milliseconds: 10));
      expect(streamedWords, contains('Need ambulance immediately'));

      await subscription.cancel();
    });

    test('6. Listening state changes propagate via statusStream', () async {
      final statuses = <SpeechRecognitionStatus>[];
      final subscription = speechService.statusStream.listen((status) {
        statuses.add(status);
      });

      await speechService.initialize();
      await speechService.startListening();
      await speechService.stopListening();

      await Future.delayed(const Duration(milliseconds: 10));

      expect(statuses, contains(SpeechRecognitionStatus.idle));
      expect(statuses, contains(SpeechRecognitionStatus.listening));
      expect(statuses, contains(SpeechRecognitionStatus.stopped));

      await subscription.cancel();
    });

    test('7. Permission denied behavior handles failure gracefully', () async {
      speechService.mockPermissionDenied = true;

      final initialized = await speechService.initialize();
      expect(initialized, isFalse);
      expect(speechService.isAvailable, isFalse);
      expect(speechService.status, equals(SpeechRecognitionStatus.permissionDenied));
      expect(speechService.lastError, contains('permission'));

      // Attempting to start listening also returns false without crashing
      final started = await speechService.startListening();
      expect(started, isFalse);
    });

    test('8. Recognition error behavior updates error state safely', () async {
      speechService.mockShouldFailInit = true;

      final initialized = await speechService.initialize();
      expect(initialized, isFalse);
      expect(speechService.status, equals(SpeechRecognitionStatus.error));
      expect(speechService.lastError, isNotNull);
    });

    test('9. Empty speech result behavior is safe and non-crashing', () async {
      await speechService.initialize();
      speechService.mockRecognizedWordsToEmit = '';

      String? resultReceived;
      final started = await speechService.startListening(
        onResult: (text) {
          resultReceived = text;
        },
      );

      expect(started, isTrue);
      expect(resultReceived, equals(''));
      expect(speechService.recognizedText, isEmpty);
    });

    test('14. Mock service locale parameter support and state manipulation', () async {
      await speechService.initialize();
      final started = await speechService.startListening(localeId: 'en_IN');
      expect(started, isTrue);

      speechService.emitRecognizedText('Fire on second floor');
      expect(speechService.recognizedText, equals('Fire on second floor'));

      speechService.setStatus(SpeechRecognitionStatus.unavailable);
      expect(speechService.status, equals(SpeechRecognitionStatus.unavailable));
    });
  });
}
