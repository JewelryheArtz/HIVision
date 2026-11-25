import 'package:material_ui/material_ui.dart';

import '../main.dart';
import '../instruction/scan_navigation.dart';
import '../widgets/app_components.dart';
import 'scan_history.dart';

// !!!!!!!!!!!!!!!!!!!!!!!!!!!  TODO (DATABASE PARTNER)  !!!!!!!!!!!!!!!!!!!!!!!!
// DUMMY DATA: replace with real data once the database is connected.
class _DemoData {
  static const recordId = 'ST-018';
  static const scanMethod = 'Self-test image scan';
  static const historyLabel = 'SAVED TO HISTORY · DEMO';
}

/// History · Non-reactive record screen (`lib/main_pages/history_non_reactive_record.dart`).
/// Displays a saved non-reactive scan record with dynamic received date/time,
/// window period guidance, care lookup, and retest reminder status.
class HistoryNonReactiveRecordScreen extends StatefulWidget {
  final String recordId;
  final DateTime? scannedAt;
  final String scanMethod;

  const HistoryNonReactiveRecordScreen({
    super.key,
    this.recordId = _DemoData.recordId,
    this.scannedAt,
    this.scanMethod = _DemoData.scanMethod,
  });

  @override
  State<HistoryNonReactiveRecordScreen> createState() =>
      _HistoryNonReactiveRecordScreenState();
}

class _HistoryNonReactiveRecordScreenState
    extends State<HistoryNonReactiveRecordScreen> {
  int _navIndex = 0;

  late final DateTime _receivedAt = widget.scannedAt ?? DateTime.now();

  String _formatDateTime(DateTime dt) {
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
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year · $hour12:$minute $period';
  }

  void _openFacilities() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const FacilitiesScreen()),
    );
  }

  void _openAllSavedScans() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ScanHistoryScreen()),
    );
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
    return Scaffold(
      body: Column(
        children: [
          const _HistoryNonReactiveHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top gray metadata card: SAVED TO HISTORY · DEMO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grayCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _DemoData.historyLabel,
                          style: AppTextStyles.overline.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatDateTime(_receivedAt),
                          style: AppTextStyles.cardTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Record ${widget.recordId} · ${widget.scanMethod}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pink alert card: NON-REACTIVE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.pinkCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NON-REACTIVE',
                          style: AppTextStyles.overline.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No reaction was detected.',
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'A non-reactive result does not rule out a recent HIV infection. Timing and correct kit use affect the result.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Gray guidance card: Consider the window period
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grayCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consider the window period',
                          style: AppTextStyles.cardTitle,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Follow the kit’s retesting guidance. If you may have been exposed within the last 72 hours, seek urgent medical advice about PEP.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Primary CTA: Find care or testing
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _openFacilities,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Find care or testing'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Secondary CTA: View all saved scans
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _openAllSavedScans,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('View all saved scans'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Disclaimer caption
                  const Text(
                    'This is image-based guidance, not a diagnosis. Follow your kit’s instructions and seek professional medical advice.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 18),

                  // Bottom gray status card: Retest reminder not set
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grayCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Retest reminder not set',
                          style: AppTextStyles.cardTitle,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Use your kit’s guidance or ask a healthcare professional about when to retest.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
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

class _HistoryNonReactiveHeader extends StatelessWidget {
  const _HistoryNonReactiveHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.redDark, AppColors.redMid, AppColors.redLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  final navigator = Navigator.of(context);

                  if (navigator.canPop()) {
                    navigator.pop();
                  } else {
                    goToHome(context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(AppIcons.back, color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Saved test guidance',
                style: AppTextStyles.headerTitle,
              ),
              const SizedBox(height: 6),
              const Text(
                'Understanding a non-reactive result',
                style: AppTextStyles.headerSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
