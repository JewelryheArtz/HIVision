import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

import '../main.dart';
import '../instruction/scan_navigation.dart';
import '../instruction/scan_result.dart';
import '../widgets/app_components.dart';
import 'scan_active_session.dart';
import 'scan_saved_record.dart';

// !!!!!!!!!!!!!!!!!!!!!!!!!!!  TODO (DATABASE PARTNER)  !!!!!!!!!!!!!!!!!!!!!!!!
// DUMMY DATA: replace with real data once the database is connected.
class _DemoData {
  static const fileName = 'test-image-018.jpg';
  static const sourceLabel = 'Demo attachment';
  static final selectedAt = DateTime(2026, 11, 18, 10, 5);
}

/// Scan · Image selected screen (`lib/main_pages/scan_image_selected.dart`).
/// Displays the selected/captured test strip preview, image quality checks,
/// and "Use image & analyze" / "Retake photo" actions.
class ScanImageSelectedScreen extends StatefulWidget {
  final Uint8List? imageBytes;
  final ImageProvider<Object>? imageProvider;
  final String? sourceLabel;
  final String? fileName;
  final DateTime? selectedAt;

  const ScanImageSelectedScreen({
    super.key,
    this.imageBytes,
    this.imageProvider,
    this.sourceLabel,
    this.fileName,
    this.selectedAt,
  });

  @override
  State<ScanImageSelectedScreen> createState() =>
      _ScanImageSelectedScreenState();
}

class _ScanImageSelectedScreenState extends State<ScanImageSelectedScreen> {
  int _navIndex = 0;
  bool _analyzing = false;

  ImageProvider<Object>? get _resolvedImage {
    if (widget.imageProvider != null) return widget.imageProvider;
    if (widget.imageBytes != null) return MemoryImage(widget.imageBytes!);
    return null;
  }

  Future<void> _useImageAndAnalyze() async {
    if (_analyzing) return;

    setState(() => _analyzing = true);

    try {
      final result = await ScanAnalyzer.analyze(fileName: widget.fileName);

      if (!mounted) return;

      SavedScanRecord.addAnalyzedScan(
        result: result,
        recordedAt: widget.selectedAt ?? DateTime.now(),
        fileName: widget.fileName ?? _DemoData.fileName,
        scanMethod: widget.sourceLabel ?? _DemoData.sourceLabel,
      );

      await ScanAnalyzer.openResult(context, result);
    } finally {
      if (mounted) {
        setState(() => _analyzing = false);
      }
    }
  }

  // Opens the camera screen for a new photo.
  void _retakePhoto() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ScanActiveSessionScreen()),
    );
  }

  void _onNavTap(int index) {
    if (index == 0) {
      goToHome(context);
      return;
    }

    setState(() => _navIndex = index);
  }

  String _selectionTimeLabel(DateTime selectedAt) {
    final now = DateTime.now();

    final isToday =
        selectedAt.year == now.year &&
        selectedAt.month == now.month &&
        selectedAt.day == now.day;

    return isToday
        ? 'Selected today · ${formatScanTime(selectedAt)}'
        : 'Selected ${formatScanTimestamp(selectedAt)}';
  }

  @override
  Widget build(BuildContext context) {
    final image = _resolvedImage;
    final selectedAt = widget.selectedAt;

    final selectedAtLabel = selectedAt == null
        ? formatScanTimestamp(_DemoData.selectedAt)
        : _selectionTimeLabel(selectedAt);

    return Scaffold(
      body: Column(
        children: [
          const AppGradientHeader(
            title: 'Review your image',
            subtitle: 'Check the selected image before continuing',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STEP 2 OF 2 · REVIEW',
                    style: AppTextStyles.overline,
                  ),

                  const SizedBox(height: 14),

                  _ImageSelectedPreviewCard(image: image),

                  const SizedBox(height: 14),

                  _ImageSelectedReviewStatusCard(
                    color: AppColors.pinkCard,
                    title: widget.fileName ?? _DemoData.fileName,
                    body:
                        '$selectedAtLabel\n'
                        '${widget.sourceLabel ?? _DemoData.sourceLabel} · Not yet analysed',
                  ),

                  const SizedBox(height: 12),

                  const _ImageSelectedReviewStatusCard(
                    color: AppColors.grayCard,
                    title: 'Check image quality',
                    body: 'The full result window should be in focus, fully visible and free from glare.',
                  ),

                  const SizedBox(height: 12),

                  const _ImageSelectedReviewStatusCard(
                    color: AppColors.grayCard,
                    title: 'Check the reading window',
                    body: 'Only continue at the time specified by the manufacturer.',
                  ),

                  const SizedBox(height: 18),

                  // Primary CTA: Use image & analyze
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _analyzing ? null : _useImageAndAnalyze,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: Text(
                        _analyzing ? 'Analyzing...' : 'Use image & analyze',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Secondary CTA: Retake photo
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _analyzing ? null : _retakePhoto,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Retake photo'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Analysis runs on your device. If confidence is too low, guidance will be shown as inconclusive. Illustration and information are for demo only.',
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

class _ImageSelectedPreviewCard extends StatelessWidget {
  final ImageProvider<Object>? image;

  const _ImageSelectedPreviewCard({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grayCard,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: image != null
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.45,
                  child: Image(
                    image: image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Selected test image preview',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 34, 24, 16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 76,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 96,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.grayCard,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.border,
                              width: 4,
                            ),
                          ),
                        ),

                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.border,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  const Text(
                    'Illustration only · Not a real test image',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
    );
  }
}

class _ImageSelectedReviewStatusCard extends StatelessWidget {
  final Color color;
  final String title;
  final String body;

  const _ImageSelectedReviewStatusCard({
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(color == AppColors.pinkCard ? 14 : 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 6),
          Text(body, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
