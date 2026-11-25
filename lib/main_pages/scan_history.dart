import 'package:material_ui/material_ui.dart';

import '../instruction/scan_navigation.dart';
import '../instruction/scan_result.dart';
import '../main.dart';
import '../widgets/app_components.dart';
import 'history_inconclusive_record.dart';
import 'history_invalid_record.dart';
import 'history_non_reactive_record.dart';
import 'history_reactive_record.dart';
import 'scan_saved_record.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  int _navIndex = 0;

  void _openRecord(SavedScanRecord record) {
    final Widget page = switch (record.result) {
      ScanResult.reactive => HistoryReactiveRecordScreen(
        recordId: record.id,
        scannedAt: record.recordedAt,
        scanMethod: record.scanMethod,
      ),
      ScanResult.nonReactive => HistoryNonReactiveRecordScreen(
        recordId: record.id,
        scannedAt: record.recordedAt,
        scanMethod: record.scanMethod,
      ),
      ScanResult.invalid => HistoryInvalidRecordScreen(
        recordId: record.id,
        scannedAt: record.recordedAt,
        scanMethod: record.scanMethod,
      ),
      ScanResult.inconclusive => HistoryInconclusiveRecordScreen(
        recordId: record.id,
        scannedAt: record.recordedAt,
        scanMethod: record.scanMethod,
      ),
    };

    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  void _onNavTap(int index) {
    if (index == 0) {
      goToHome(context);
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final records = SavedScanRecord.demoRecords;

    return Scaffold(
      body: Column(
        children: [
          const AppGradientHeader(
            title: 'Saved scan history',
            subtitle: 'View the result and guidance for each saved scan',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RECENT ACTIVITY', style: AppTextStyles.overline),
                  const SizedBox(height: 14),
                  for (var index = 0; index < records.length; index++) ...[
                    _ScanHistoryRecordCard(
                      record: records[index],
                      isLatest: index == 0,
                      onTap: () => _openRecord(records[index]),
                    ),
                    if (index != records.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _ScanHistoryRecordCard extends StatelessWidget {
  const _ScanHistoryRecordCard({
    required this.record,
    required this.isLatest,
    required this.onTap,
  });

  final SavedScanRecord record;
  final bool isLatest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Material(
        color: isLatest ? AppColors.pinkCard : AppColors.grayCard,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.resultLabel,
                  style: AppTextStyles.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  record.timestampLabel(),
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  record.summary,
                  style: AppTextStyles.caption,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
