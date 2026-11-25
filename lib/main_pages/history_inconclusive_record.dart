import 'package:material_ui/material_ui.dart';

import '../main.dart';
import '../instruction/scan_navigation.dart';
import '../widgets/app_components.dart';
import 'scan_active_session.dart';
import 'scan_history.dart';

// !!!!!!!!!!!!!!!!!!!!!!!!!!!  TODO (DATABASE PARTNER)  !!!!!!!!!!!!!!!!!!!!!!!!
// DUMMY DATA: replace with real data once the database is connected.
class _DemoData {
  static const recordId = 'ST-017';
  static const scanMethod = 'Self-test image scan';
  static const historyLabel = 'SAVED TO HISTORY · DEMO';
}

/// History · Inconclusive record screen (`lib/main_pages/history_inconclusive_record.dart`).
/// Displays a saved inconclusive scan record with dynamic received date/time,
/// image clarity guidance, retake action, and pending image status.
class HistoryInconclusiveRecordScreen extends StatefulWidget {
  final String recordId;
  final DateTime? scannedAt;
  final String scanMethod;

  const HistoryInconclusiveRecordScreen({
    super.key,
    this.recordId = _DemoData.recordId,
    this.scannedAt,
    this.scanMethod = _DemoData.scanMethod,
  });

  @override
  State<HistoryInconclusiveRecordScreen> createState() =>
      _HistoryInconclusiveRecordScreenState();
}

class _HistoryInconclusiveRecordScreenState
    extends State<HistoryInconclusiveRecordScreen> {
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

  void _retakePhoto() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ScanActiveSessionScreen()),
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
          const _HistoryInconclusiveHeader(),
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

                  // Pink alert card: INCONCLUSIVE
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
                          'INCONCLUSIVE',
                          style: AppTextStyles.overline.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'I couldn’t interpret this image.',
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'The image analysis is not confident enough to suggest a result. Do not treat this as reactive or non-reactive.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Gray guidance card: Try a clearer image
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
                          'Try a clearer image',
                          style: AppTextStyles.cardTitle,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Retake the photo with the full result window in focus. If the test itself is unclear, follow the kit instructions or contact a care provider.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Primary CTA: Retake photo
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _retakePhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Retake photo'),
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

                  // Bottom gray status card: New image not added
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
                          'New image not added',
                          style: AppTextStyles.cardTitle,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'This record remains inconclusive until a new image is assessed.',
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

class _HistoryInconclusiveHeader extends StatelessWidget {
  const _HistoryInconclusiveHeader();

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
                'The image result is uncertain',
                style: AppTextStyles.headerSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
