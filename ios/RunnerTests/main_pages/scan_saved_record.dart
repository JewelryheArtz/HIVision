import 'package:material_ui/material_ui.dart';

import '../instruction/scan_result.dart';
import 'history_inconclusive_record.dart';
import 'history_invalid_record.dart';
import 'history_non_reactive_record.dart';
import 'history_reactive_record.dart';

class SavedScanRecord {
  const SavedScanRecord({
    required this.id,
    required this.result,
    required this.recordedAt,
    required this.summary,
    this.scanMethod = 'Self-test image scan',
    this.fileName,
    this.isSampleTimestamp = false,
  });

  final String id;
  final ScanResult result;
  final DateTime recordedAt;
  final String summary;
  final String scanMethod;
  final String? fileName;
  final bool isSampleTimestamp;

  String get resultLabel => switch (result) {
    ScanResult.reactive => 'Reactive',
    ScanResult.nonReactive => 'Non-reactive',
    ScanResult.inconclusive => 'Image could not be interpreted',
    ScanResult.invalid => 'Invalid',
  };

  String timestampLabel() {
    final samplePrefix = isSampleTimestamp ? 'Demo sample · ' : '';
    return '$samplePrefix${formatScanTimestamp(recordedAt)} · $id';
  }

  Widget toHistoryRecordScreen() {
    return switch (result) {
      ScanResult.reactive => HistoryReactiveRecordScreen(
        recordId: id,
        scannedAt: recordedAt,
        scanMethod: scanMethod,
      ),
      ScanResult.nonReactive => HistoryNonReactiveRecordScreen(
        recordId: id,
        scannedAt: recordedAt,
        scanMethod: scanMethod,
      ),
      ScanResult.invalid => HistoryInvalidRecordScreen(
        recordId: id,
        scannedAt: recordedAt,
        scanMethod: scanMethod,
      ),
      ScanResult.inconclusive => HistoryInconclusiveRecordScreen(
        recordId: id,
        scannedAt: recordedAt,
        scanMethod: scanMethod,
      ),
    };
  }

  // Stores completed scans during the current app session.
  static final List<SavedScanRecord> demoRecords = [];

  // Gets the most recently completed scan.
  static SavedScanRecord? get latestRecord {
    if (demoRecords.isEmpty) return null;
    return demoRecords.first;
  }

  static Future<void> openLatestHistoryRecord(BuildContext context) async {
    final latest = latestRecord;

    if (latest == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => latest.toHistoryRecordScreen()),
    );
  }

  // Saves the result before opening its corresponding result screen.
  static void addAnalyzedScan({
    required ScanResult result,
    required DateTime recordedAt,
    required String fileName,
    required String scanMethod,
  }) {
    final previousNumber = demoRecords.isEmpty
        ? 0
        : int.tryParse(demoRecords.first.id.replaceFirst('ST-', '')) ?? 0;

    final recordId = 'ST-${(previousNumber + 1).toString().padLeft(3, '0')}';

    final summary = switch (result) {
      ScanResult.reactive => 'Follow-up testing is recommended.',
      ScanResult.nonReactive =>
        'No reaction was detected. A recent infection is not ruled out.',
      ScanResult.inconclusive => 'A clearer image was needed.',
      ScanResult.invalid =>
        'Follow the kit instructions and repeat with a new kit.',
    };

    demoRecords.insert(
      0,
      SavedScanRecord(
        id: recordId,
        result: result,
        recordedAt: recordedAt,
        summary: summary,
        fileName: fileName,
        scanMethod: scanMethod,
      ),
    );
  }

  static void resetDemoRecords() {
    demoRecords.clear();
  }
}

String formatScanTimestamp(DateTime dateTime) {
  return '${_formatScanDate(dateTime)} · ${formatScanTime(dateTime)}';
}

String formatScanTime(DateTime dateTime) {
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour < 12 ? 'AM' : 'PM';

  return '$hour:$minute $period';
}

String _formatScanDate(DateTime dateTime) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
}
