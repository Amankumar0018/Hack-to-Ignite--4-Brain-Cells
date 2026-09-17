import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pukaar/core/models/emergency_enums.dart';
import 'package:pukaar/core/models/emergency_incident.dart';
import 'package:pukaar/core/services/emergency_service.dart';
import 'package:pukaar/core/services/service_locator.dart';
import 'package:pukaar/core/services/speech_service.dart';
import 'package:pukaar/core/utils/app_result.dart';
import 'package:pukaar/features/emergency/presentation/screens/emergency_intent_screen.dart';
import 'package:pukaar/features/emergency/presentation/widgets/voice_emergency_input_card.dart';

class TrackingMockEmergencyService implements EmergencyService {
  int createIncidentCallCount = 0;
  String? lastNotes;
  String? lastIntent;
  EmergencyCategory? lastCategory;

  @override
  EmergencyIncident? get activeIncident => null;

  @override
  Stream<EmergencyIncident> get incidentStream => const Stream.empty();

  @override
  Future<AppResult<EmergencyIncident>> createIncident({
    required EmergencyCategory category,
    required String intent,
    EmergencyPriority priority = EmergencyPriority.high,
    double? latitude,
    double? longitude,
    double? accuracy,
    String? userId,
    String? notes,
  }) async {
    createIncidentCallCount++;
    lastCategory = category;
    lastIntent = intent;
    lastNotes = notes;

    final incident = EmergencyIncident(
      id: 'INC_TEST_101',
      userId: 'test_user',
      category: category,
      intent: intent,
      priority: priority,
      status: EmergencyStatus.created,
      timestamp: DateTime.now(),
      notes: notes,
    );
    return AppResult.success(incident);
  }

  @override
  Future<AppResult<EmergencyIncident>> cancelIncident(String incidentId, {String? reason}) async =>
      AppResult.failure('Not implemented');

  @override
  Future<AppResult<List<EmergencyIncident>>> getActiveIncidents() async =>
      AppResult.success([]);

  @override
  Future<AppResult<List<EmergencyIncident>>> getAllIncidents() async =>
      AppResult.success([]);

  @override
  Future<AppResult<EmergencyIncident>> getIncidentById(String incidentId) async =>
      AppResult.failure('Not implemented');

  @override
  Future<AppResult<EmergencyIncident>> updateIncidentStatus(
    String incidentId,
    EmergencyStatus newStatus, {
    String? responderId,
    String? responderName,
    String? responderPhone,
    String? responderType,
    double? responderLat,
    double? responderLng,
    int? etaMinutes,
  }) async =>
      AppResult.failure('Not implemented');

  @override
  void dispose() {}
}

void main() {
  late MockSpeechService mockSpeechService;
  late TrackingMockEmergencyService mockEmergencyService;

  setUp(() {
    mockSpeechService = MockSpeechService();
    mockEmergencyService = TrackingMockEmergencyService();

    ServiceLocator.instance.init(
      customSpeechService: mockSpeechService,
      customEmergencyService: mockEmergencyService,
    );
  });

  tearDown(() {
    mockSpeechService.dispose();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );
  }

  testWidgets('10. Voice UI renders in idle state with mic button and editable text field',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      buildTestableWidget(
        VoiceEmergencyInputCard(
          controller: controller,
          speechService: mockSpeechService,
        ),
      ),
    );

    // Verify mic icon and initial prompts
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
    expect(find.text('Describe Emergency by Voice'), findsOneWidget);
    expect(find.text('Tap mic and speak, or type directly'), findsOneWidget);

    // Verify editable TextFormField is present
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('11. Voice UI listening state updates visually when microphone is tapped',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      buildTestableWidget(
        VoiceEmergencyInputCard(
          controller: controller,
          speechService: mockSpeechService,
        ),
      ),
    );

    // Tap the microphone button
    await tester.tap(find.byIcon(Icons.mic_none_rounded));
    await tester.pump();

    // Verify state transition to listening
    expect(mockSpeechService.isListening, isTrue);
    expect(find.text('Listening... Speak now'), findsOneWidget);
    expect(find.text('Tap mic to stop when done'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tap mic again to stop
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pump();

    expect(mockSpeechService.isListening, isFalse);
  });

  testWidgets('12. Voice result appears in editable text field and can be manually edited',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      buildTestableWidget(
        VoiceEmergencyInputCard(
          controller: controller,
          speechService: mockSpeechService,
        ),
      ),
    );

    // Simulate recognized speech text event
    mockSpeechService.emitRecognizedText('Person collapsed near library');
    await tester.pump();

    // Verify text appeared in controller and on screen
    expect(controller.text, equals('Person collapsed near library'));
    expect(find.text('Person collapsed near library'), findsOneWidget);
    expect(find.text('Voice Input Recorded'), findsOneWidget);

    // User can manually edit or append text with normal typing
    await tester.enterText(find.byType(TextFormField), 'Person collapsed near library, unconscious');
    await tester.pump();

    expect(controller.text, equals('Person collapsed near library, unconscious'));
  });

  testWidgets('13. Voice feature does NOT automatically submit an incident',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/emergency-tracking': (context) => const Scaffold(body: Text('Tracking Screen')),
        },
        home: const EmergencyIntentScreen(category: 'Medical Emergency'),
      ),
    );

    // Scroll to make 'Unconscious Person' visible (VoiceCard now appears above the list)
    await tester.ensureVisible(find.text('Unconscious Person'));
    await tester.pumpAndSettle();

    // Select an intent option
    await tester.tap(find.text('Unconscious Person'));
    await tester.pump();

    // Simulate speech input
    mockSpeechService.emitRecognizedText('There is an unconscious student on floor 2');
    await tester.pump();

    // Crucial check: emergency creation must NOT have been called automatically!
    expect(mockEmergencyService.createIncidentCallCount, equals(0));

    // Emergency is only submitted when user explicitly taps "Confirm Emergency Request"
    await tester.ensureVisible(find.text('Confirm Emergency Request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm Emergency Request'));
    await tester.pump();

    expect(mockEmergencyService.createIncidentCallCount, equals(1));
    expect(mockEmergencyService.lastCategory, equals(EmergencyCategory.medical));
    expect(mockEmergencyService.lastIntent, equals('Unconscious Person'));
    expect(mockEmergencyService.lastNotes, equals('There is an unconscious student on floor 2'));
  });

  testWidgets('Voice UI gracefully shows permission denied message and retry button',
      (WidgetTester tester) async {
    mockSpeechService.mockPermissionDenied = true;
    final controller = TextEditingController();

    await tester.pumpWidget(
      buildTestableWidget(
        VoiceEmergencyInputCard(
          controller: controller,
          speechService: mockSpeechService,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.mic_none_rounded));
    await tester.pump();

    expect(find.textContaining('permission denied'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
