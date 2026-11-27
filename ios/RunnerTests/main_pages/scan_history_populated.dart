import 'package:material_ui/material_ui.dart';

import '../instruction/scan_instructions.dart';
import '../instruction/scan_navigation.dart';
import '../main.dart';
import '../widgets/app_components.dart';
import 'scan_saved_record.dart';

// !!!!!!!!!!!!!!!!!!!!!!!!!!!  TODO (DATABASE PARTNER)  !!!!!!!!!!!!!!!!!!!!!!!!
// DUMMY DATA: replace with real data once the database is connected.
class _DemoData {
  static const periodLabel = 'NOVEMBER 2026';
}

/// Scan history · Populated screen (`lib/main_pages/scan_history_populated.dart`).
/// Displays all saved scan records and routes each card directly to its
/// corresponding individual History record screen.
class ScanHistoryPopulatedScreen extends StatefulWidget {
  const ScanHistoryPopulatedScreen({super.key});

  @override
  State<ScanHistoryPopulatedScreen> createState() =>
      _ScanHistoryPopulatedScreenState();
}

class _ScanHistoryPopulatedScreenState
    extends State<ScanHistoryPopulatedScreen> {
  int _navIndex = 0;

  void _openRecord(SavedScanRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => record.toHistoryRecordScreen()),
    );
  }

  Future<void> _scanNewTest() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ScanInstructionsScreen()),
    );
    if (mounted) setState(() {});
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
            title: 'Your scan history',
            subtitle: 'Saved scans and their guidance',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${records.length} saved scans',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Demo records · All dates',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 6),

                  const Text(
                    'Each scan is a separate record, not a trend or a confirmed diagnosis.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    _DemoData.periodLabel,
                    style: AppTextStyles.overline,
                  ),
                  const SizedBox(height: 14),

                  for (int i = 0; i < records.length; i++) ...[
                    _PopulatedHistoryScanCard(
                      dateLabel: formatScanTimestamp(records[i].recordedAt),
                      recordId: records[i].id,
                      resultTitle: records[i].resultLabel,
                      summary: records[i].summary,
                      isLatest: i == 0,
                      onTap: () => _openRecord(records[i]),
                    ),
                    if (i != records.length - 1) const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 18),

                  // Primary CTA: Scan a new test
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _scanNewTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Scan a new test'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Past scans cannot confirm or overturn a diagnosis. Follow the kit instructions and seek professional medical advice.',
                    style: AppTextStyles.caption,
                  ),
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

class _PopulatedHistoryScanCard extends StatelessWidget {
  final String dateLabel;
  final String recordId;
  final String resultTitle;
  final String summary;
  final bool isLatest;
  final VoidCallback onTap;

  const _PopulatedHistoryScanCard({
    required this.dateLabel,
    required this.recordId,
    required this.resultTitle,
    required this.summary,
    required this.isLatest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isLatest ? AppColors.pinkCard : AppColors.grayCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateLabel, style: AppTextStyles.caption),
                  Text(recordId, style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: 8),
              Text(resultTitle, style: AppTextStyles.cardTitle),
              const SizedBox(height: 6),
              Text(summary, style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Text(
                'View saved guidance',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
