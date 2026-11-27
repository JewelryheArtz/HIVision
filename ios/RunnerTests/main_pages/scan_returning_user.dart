import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../instruction/scan_navigation.dart';
import '../instruction/scan_result.dart';
import '../widgets/app_components.dart';
import 'scan_active_session.dart';
import 'scan_history_populated.dart';
import 'scan_saved_record.dart';

// !!!!!!!!!!!!!!!!!!!!!!!!!!!  TODO (DATABASE PARTNER)  !!!!!!!!!!!!!!!!!!!!!!!!
// DUMMY DATA: replace with real data once the database is connected.
class _DemoData {
  static const returningUserLabel = 'RETURNING USER · DEMO';
}

/// Returning user scan hub under `lib/main_pages/`.
/// Shows the user's last saved scan summary, preparation steps,
/// direct camera/upload actions, and a dynamic link to view all saved scans.
class ScanReturningUserScreen extends StatefulWidget {
  const ScanReturningUserScreen({super.key, this.imagePicker});

  final ImagePicker? imagePicker;

  @override
  State<ScanReturningUserScreen> createState() =>
      _ScanReturningUserScreenState();
}

class _ScanReturningUserScreenState extends State<ScanReturningUserScreen> {
  int _navIndex = 0;

  void _openCamera() {
    _openScanSession(ImageSource.camera);
  }

  void _uploadTestImage() {
    _openScanSession(ImageSource.gallery);
  }

  Future<void> _openScanSession(ImageSource source) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ScanActiveSessionScreen(
          initialSource: source,
          imagePicker: widget.imagePicker,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  void _openSavedGuidance() {
    ScanAnalyzer.openResult(context, ScanResult.nonReactive);
  }

  Future<void> _openAllSavedScans() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const ScanHistoryPopulatedScreen(),
      ),
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
    final totalScans = SavedScanRecord.demoRecords.length;

    return Scaffold(
      body: Column(
        children: [
          const AppGradientHeader(
            title: 'HIV Self-Testing',
            subtitle: 'Start a new scan or revisit your history',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    _DemoData.returningUserLabel,
                    style: AppTextStyles.overline,
                  ),
                  const SizedBox(height: 14),

                  // Last saved scan highlight card (AppColors.pinkCard)
                  _ReturningLastSavedScanCard(
                    record: SavedScanRecord.demoRecords.first,
                    onTap: _openSavedGuidance,
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Ready for a new test?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Each new test is a separate scan. Follow your kit’s instructions and its reading time.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 16),

                  // Preparation Step Cards
                  const _ReturningStepCard(
                    stepNumber: '1',
                    title: 'Prepare the test',
                    body: 'Complete all steps in the manufacturer’s instructions.',
                  ),
                  const SizedBox(height: 12),
                  const _ReturningStepCard(
                    stepNumber: '2',
                    title: 'Use good lighting',
                    body: 'Use a flat surface. Avoid glare, blur and shadows.',
                  ),
                  const SizedBox(height: 12),
                  const _ReturningStepCard(
                    stepNumber: '3',
                    title: 'Keep the result window visible',
                    body: 'Include the full test strip and control area in your image.',
                  ),
                  const SizedBox(height: 18),

                  // Primary CTA: Open camera
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _openCamera,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Open camera'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Secondary CTA: Upload a test image
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _uploadTestImage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Upload a test image'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dynamic link to view all saved scans with light-red hover
                  _ReturningViewAllSavedScansLink(
                    count: totalScans,
                    onTap: _openAllSavedScans,
                  ),
                  const SizedBox(height: 10),

                  // Disclaimer caption
                  const Text(
                    'Image-based guidance is not a diagnosis. Demo information only.',
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

class _ReturningViewAllSavedScansLink extends StatefulWidget {
  final int count;
  final VoidCallback onTap;

  const _ReturningViewAllSavedScansLink({
    required this.count,
    required this.onTap,
  });

  @override
  State<_ReturningViewAllSavedScansLink> createState() =>
      _ReturningViewAllSavedScansLinkState();
}

class _ReturningViewAllSavedScansLinkState
    extends State<_ReturningViewAllSavedScansLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.pinkCard : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'View all ${widget.count} saved scans',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _hovered ? AppColors.redLight : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReturningLastSavedScanCard extends StatelessWidget {
  final SavedScanRecord record;
  final VoidCallback onTap;

  const _ReturningLastSavedScanCard({
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pinkCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your last saved scan',
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: 6),
              Text(record.timestampLabel(), style: AppTextStyles.caption),
              const SizedBox(height: 6),
              Text(
                record.resultLabel,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'View saved guidance',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturningStepCard extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String body;

  const _ReturningStepCard({
    required this.stepNumber,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grayCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$stepNumber  $title', style: AppTextStyles.cardTitle),
          const SizedBox(height: 6),
          Text(body, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
