// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import 'package:hivision/instruction/scan_capture.dart';
import 'package:hivision/instruction/scan_instructions.dart';
import 'package:hivision/instruction/scan_inconclusive.dart';
import 'package:hivision/instruction/scan_invalid.dart';
import 'package:hivision/instruction/scan_non_reactive.dart';
import 'package:hivision/instruction/scan_reactive.dart';
import 'package:hivision/instruction/scan_review.dart';
import 'package:hivision/instruction/scan_result.dart';
import 'package:hivision/main.dart';
import 'package:hivision/main_pages/home_with_activity.dart';
import 'package:hivision/main_pages/history_inconclusive_record.dart';
import 'package:hivision/main_pages/history_invalid_record.dart';
import 'package:hivision/main_pages/history_non_reactive_record.dart';
import 'package:hivision/main_pages/history_reactive_record.dart';
import 'package:hivision/main_pages/main_pages_demo.dart' show MainPagesDemoApp;
import 'package:hivision/main_pages/scan_active_session.dart';
import 'package:hivision/main_pages/scan_history.dart';
import 'package:hivision/main_pages/scan_image_selected.dart';
import 'package:hivision/main_pages/scan_returning_user.dart';
import 'package:hivision/main_pages/scan_saved_record.dart';

void main() {
  setUp(SavedScanRecord.resetDemoRecords);

  testWidgets('Home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Your health companion'), findsOneWidget);
    expect(find.text('How can I help today?'), findsOneWidget);
    expect(find.text('Self-test scanner'), findsOneWidget);
  });

  testWidgets('Home with activity shows latest scan and care tools', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeWithActivityScreen()));

    expect(find.text('Welcome back, Alex'), findsOneWidget);
    expect(find.text('Pick up where you left off'), findsOneWidget);
    expect(find.text('Non-reactive'), findsOneWidget);
    expect(find.text('Image could not be interpreted'), findsOneWidget);
    expect(find.text('Facilities near me'), findsOneWidget);
    expect(find.text('Medication assistant'), findsOneWidget);
  });

  testWidgets('Main pages demo starts on activity dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MainPagesDemoApp());

    expect(find.text('Welcome back, Alex'), findsOneWidget);
  });

  testWidgets('Home activity scan action opens scan instructions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeWithActivityScreen()));

    await tester.tap(find.text('Scan a new test'));
    await tester.pumpAndSettle();

    expect(find.byType(ScanInstructionsScreen), findsOneWidget);
  });

  testWidgets('Home activity history and guidance links open their pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeWithActivityScreen()));

    await tester.tap(find.text('View history'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanHistoryScreen), findsOneWidget);
    expect(find.text('Reactive'), findsOneWidget);
    expect(find.text('Non-reactive'), findsOneWidget);
    expect(find.text('Invalid'), findsOneWidget);
    expect(find.text('Image could not be interpreted'), findsOneWidget);

    await tester.tap(find.text('Non-reactive'));
    await tester.pumpAndSettle();
    expect(find.byType(HistoryNonReactiveRecordScreen), findsOneWidget);

    Navigator.of(tester.element(find.byType(HistoryNonReactiveRecordScreen)))
        .pop();
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(ScanHistoryScreen))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('View saved guidance'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanNonReactiveScreen), findsOneWidget);
  });

  testWidgets('Latest analyzed filename selects its history record page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScanImageSelectedScreen(
          fileName: 'demo-reactive-result.jpg',
          sourceLabel: 'Uploaded image',
          selectedAt: DateTime(2026, 11, 25, 10, 5),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Use image & analyze'));
    await tester.tap(find.text('Use image & analyze'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanReactiveScreen), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.back).first);
    await tester.pumpAndSettle();
    expect(find.byType(HomeWithActivityScreen), findsOneWidget);

    await tester.tap(find.text('View history'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanHistoryScreen), findsOneWidget);
    expect(find.textContaining('ST-019'), findsOneWidget);

    await tester.tap(find.text('Reactive').first);
    await tester.pumpAndSettle();
    expect(find.byType(HistoryReactiveRecordScreen), findsOneWidget);
    expect(find.textContaining('ST-019'), findsOneWidget);
  });

  testWidgets('View history opens the record page for each result kind', (
    WidgetTester tester,
  ) async {
    final cases = <(ScanResult, String, Type)>[
      (ScanResult.reactive, 'Reactive', HistoryReactiveRecordScreen),
      (ScanResult.nonReactive, 'Non-reactive', HistoryNonReactiveRecordScreen),
      (ScanResult.invalid, 'Invalid', HistoryInvalidRecordScreen),
      (
        ScanResult.inconclusive,
        'Image could not be interpreted',
        HistoryInconclusiveRecordScreen,
      ),
    ];

    for (final (result, label, pageType) in cases) {
      SavedScanRecord.resetDemoRecords();
      SavedScanRecord.addAnalyzedScan(
        result: result,
        recordedAt: DateTime(2026, 11, 25, 10, 5),
        fileName: 'demo-${result.name}.jpg',
        scanMethod: 'Uploaded image',
      );
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey<ScanResult>(result),
          home: const HomeWithActivityScreen(),
        ),
      );

      await tester.tap(find.text('View history'));
      await tester.pumpAndSettle();
      expect(find.byType(ScanHistoryScreen), findsOneWidget);
      await tester.tap(find.text(label).first);
      await tester.pumpAndSettle();
      expect(find.byType(pageType), findsOneWidget);

      Navigator.of(tester.element(find.byType(pageType))).pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Returning user last saved scan opens its guidance', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ScanReturningUserScreen()));

    await tester.tap(find.text('Your last saved scan'));
    await tester.pumpAndSettle();

    expect(find.byType(ScanNonReactiveScreen), findsOneWidget);
  });

  testWidgets(
    'Returning user camera action opens session with captured image',
    (WidgetTester tester) async {
      final pngBytes = Uint8List.fromList(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC',
        ),
      );
      final fakePicker = _FakeImagePicker(
        XFile.fromData(pngBytes, path: 'demo-reactive-captured.jpg'),
      );
      await tester.pumpWidget(
        MaterialApp(home: ScanReturningUserScreen(imagePicker: fakePicker)),
      );

      await tester.ensureVisible(find.text('Open camera'));
      await tester.tap(find.text('Open camera'));
      await tester.pumpAndSettle();

      expect(fakePicker.requestedSources, [ImageSource.camera]);
      expect(find.byType(ScanImageSelectedScreen), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.textContaining('Captured image'), findsOneWidget);
      expect(find.text('Use image & analyze'), findsOneWidget);
      expect(find.text('Retake photo'), findsOneWidget);

      await tester.ensureVisible(find.text('Use image & analyze'));
      await tester.tap(find.text('Use image & analyze'));
      await tester.pumpAndSettle();
      expect(find.byType(ScanReactiveScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Returning user upload action opens session with selected image',
    (WidgetTester tester) async {
      final pngBytes = Uint8List.fromList(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC',
        ),
      );
      final fakePicker = _FakeImagePicker(
        XFile.fromData(pngBytes, path: 'uploaded.png'),
      );
      await tester.pumpWidget(
        MaterialApp(home: ScanReturningUserScreen(imagePicker: fakePicker)),
      );

      await tester.ensureVisible(find.text('Upload a test image'));
      await tester.tap(find.text('Upload a test image'));
      await tester.pumpAndSettle();

      expect(fakePicker.requestedSources, [ImageSource.gallery]);
      expect(find.byType(ScanImageSelectedScreen), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.textContaining('Uploaded image'), findsOneWidget);
    },
  );

  testWidgets('Active session capture and upload buttons show selected image', (
    WidgetTester tester,
  ) async {
    final pngBytes = Uint8List.fromList(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC',
      ),
    );
    final fakePicker = _FakeImagePicker(
      XFile.fromData(pngBytes, path: 'test.png'),
    );
    await tester.pumpWidget(
      MaterialApp(home: ScanActiveSessionScreen(imagePicker: fakePicker)),
    );

    await tester.ensureVisible(find.text('Capture image'));
    await tester.tap(find.text('Capture image'));
    await tester.pumpAndSettle();
    expect(fakePicker.requestedSources, [ImageSource.camera]);
    expect(find.byType(ScanImageSelectedScreen), findsOneWidget);

    await tester.ensureVisible(find.text('Retake photo'));
    await tester.tap(find.text('Retake photo'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanActiveSessionScreen), findsOneWidget);

    await tester.ensureVisible(find.text('Upload from photos'));
    await tester.tap(find.text('Upload from photos'));
    await tester.pumpAndSettle();
    expect(fakePicker.requestedSources, [
      ImageSource.camera,
      ImageSource.gallery,
    ]);
    expect(find.byType(ScanImageSelectedScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('All four saved demo scans open their matching history pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ScanHistoryScreen()));

    expect(find.textContaining('ST-018'), findsOneWidget);
    expect(find.textContaining('ST-017'), findsOneWidget);
    expect(find.textContaining('ST-016'), findsOneWidget);
    expect(find.textContaining('ST-015'), findsOneWidget);
    expect(find.textContaining('Demo sample'), findsNWidgets(2));

    final records = <(String, Type)>[
      ('Non-reactive', HistoryNonReactiveRecordScreen),
      ('Image could not be interpreted', HistoryInconclusiveRecordScreen),
      ('Reactive', HistoryReactiveRecordScreen),
      ('Invalid', HistoryInvalidRecordScreen),
    ];

    for (final (label, screenType) in records) {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.byType(screenType), findsOneWidget);
      Navigator.of(tester.element(find.byType(screenType))).pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Test kits opens the main.dart home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeWithActivityScreen()));

    await tester.ensureVisible(find.text('Test kits'));
    await tester.tap(find.text('Test kits'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Result pages return home to activity dashboard', (
    WidgetTester tester,
  ) async {
    final resultScreens = <Widget>[
      const ScanReactiveScreen(),
      const ScanNonReactiveScreen(),
      const ScanInvalidScreen(),
      const ScanInconclusiveScreen(),
    ];

    for (final screen in resultScreens) {
      await tester.pumpWidget(
        MaterialApp(key: ValueKey<Type>(screen.runtimeType), home: screen),
      );
      await tester.pumpAndSettle();
      expect(find.byType(screen.runtimeType), findsOneWidget);
      await tester.tap(find.byIcon(AppIcons.back));
      await tester.pumpAndSettle();

      expect(find.byType(HomeWithActivityScreen), findsOneWidget);
    }
  });

  testWidgets('Self-test scanner opens scan instructions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Self-test scanner'));
    await tester.pumpAndSettle();

    expect(find.byType(ScanInstructionsScreen), findsOneWidget);
    expect(find.text('HIV Self-Testing'), findsOneWidget);
    expect(find.text('Follow your test kit\ninstructions.'), findsOneWidget);
  });

  testWidgets('Both scan instruction actions open the capture page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Self-test scanner'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open camera'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open camera'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanCaptureScreen), findsOneWidget);

    await tester.tap(find.text('Home').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Upload a test image'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upload a test image'));
    await tester.pumpAndSettle();

    expect(find.byType(ScanCaptureScreen), findsOneWidget);
    expect(find.text('Position the test here'), findsOneWidget);
  });

  testWidgets('Camera and gallery selections populate both preview screens', (
    WidgetTester tester,
  ) async {
    final pngBytes = Uint8List.fromList(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC',
      ),
    );
    final fakePicker = _FakeImagePicker(
      XFile.fromData(pngBytes, path: 'test.png'),
    );
    await tester.pumpWidget(
      MaterialApp(home: ScanCaptureScreen(imagePicker: fakePicker)),
    );

    await tester.ensureVisible(find.text('Capture image'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capture image'));
    await tester.pumpAndSettle();

    expect(fakePicker.requestedSources, [ImageSource.camera]);
    expect(find.byType(ScanReviewScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('IMAGE QUALITY CHECK'), findsOneWidget);

    final capturedImage = tester
        .widget<ScanReviewScreen>(find.byType(ScanReviewScreen))
        .capturedImage;
    expect(capturedImage, isNotNull);

    await tester.ensureVisible(find.text('Retake photo'));
    await tester.tap(find.text('Retake photo'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanCaptureScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(tester.widget<Image>(find.byType(Image)).image, same(capturedImage));

    await tester.ensureVisible(find.text('Upload from photos'));
    await tester.tap(find.text('Upload from photos'));
    await tester.pumpAndSettle();

    expect(fakePicker.requestedSources, [
      ImageSource.camera,
      ImageSource.gallery,
    ]);
    expect(find.byType(ScanReviewScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Capture preview box remains available before taking a photo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ScanCaptureScreen()));

    expect(find.text('Position the test here'), findsOneWidget);
    expect(find.text('Supports JPG or PNG up to 10 MB.'), findsOneWidget);
  });

  testWidgets('Use image and analyze opens inconclusive guidance', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ScanReviewScreen()));

    await tester.ensureVisible(find.text('Use image & analyze'));
    await tester.tap(find.text('Use image & analyze'));
    await tester.pumpAndSettle();

    expect(find.byType(ScanInconclusiveScreen), findsOneWidget);
    expect(find.text('The image result is uncertain'), findsOneWidget);
  });

  test('Demo result is selected from filename labels', () async {
    expect(
      await ScanAnalyzer.analyze(fileName: 'demo-reactive-test.jpg'),
      ScanResult.reactive,
    );
    expect(
      await ScanAnalyzer.analyze(fileName: 'demo_non_reactive_test.png'),
      ScanResult.nonReactive,
    );
    expect(
      await ScanAnalyzer.analyze(fileName: 'demo-invalid-test.jpg'),
      ScanResult.invalid,
    );
    expect(
      await ScanAnalyzer.analyze(fileName: 'demo-inconclusive-test.png'),
      ScanResult.inconclusive,
    );
    expect(
      await ScanAnalyzer.analyze(fileName: 'test-photo.jpg'),
      ScanResult.inconclusive,
    );
    expect(
      await ScanAnalyzer.analyze(
        fileName: 'demo-reactive-inconclusive-test.jpg',
      ),
      ScanResult.inconclusive,
    );
  });

  testWidgets('Review routes to the result selected by its filename', (
    WidgetTester tester,
  ) async {
    final cases = <(String, Type)>[
      ('demo-reactive.jpg', ScanReactiveScreen),
      ('demo-non-reactive.jpg', ScanNonReactiveScreen),
      ('demo-invalid.jpg', ScanInvalidScreen),
      ('demo-inconclusive.jpg', ScanInconclusiveScreen),
    ];

    for (final (fileName, resultPageType) in cases) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey<String>(fileName),
          home: ScanReviewScreen(fileName: fileName),
        ),
      );
      await tester.ensureVisible(find.text('Use image & analyze'));
      await tester.tap(find.text('Use image & analyze'));
      await tester.pumpAndSettle();

      expect(find.byType(resultPageType), findsOneWidget);
    }
  });
}

class _FakeImagePicker extends ImagePicker {
  _FakeImagePicker(this.image);

  final XFile image;
  final List<ImageSource> requestedSources = [];

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    requestedSources.add(source);
    return image;
  }
}
