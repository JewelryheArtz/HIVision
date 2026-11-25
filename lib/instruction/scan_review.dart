import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

import '../main.dart';
import '../main_pages/scan_saved_record.dart';
import 'scan_capture.dart';
import 'scan_result.dart';
import 'scan_navigation.dart';

class ScanReviewScreen extends StatefulWidget {
  const ScanReviewScreen({
    super.key,
    this.capturedImage,
    this.imageBytes,
    this.sourceLabel,
    this.fileName,
  });

  final ImageProvider<Object>? capturedImage;
  final Uint8List? imageBytes;
  final String? sourceLabel;
  final String? fileName;

  @override
  State<ScanReviewScreen> createState() => _ScanReviewScreenState();
}

class _ScanReviewScreenState extends State<ScanReviewScreen> {
  int _navIndex = 0;
  bool _analyzing = false;

  ImageProvider<Object>? get _resolvedImage {
    if (widget.capturedImage != null) {
      return widget.capturedImage;
    }

    if (widget.imageBytes != null) {
      return MemoryImage(widget.imageBytes!);
    }

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
        recordedAt: DateTime.now(),
        fileName: widget.fileName ?? 'Selected image',
        scanMethod: widget.sourceLabel ?? 'Self-test image scan',
      );

      await ScanAnalyzer.openResult(context, result);
    } finally {
      if (mounted) {
        setState(() => _analyzing = false);
      }
    }
  }

  void _retakePhoto() {
    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      // Returns to the ScanCaptureScreen that opened this review screen.
      navigator.pop();
    } else {
      // Opens the capture screen if there is no previous route.
      navigator.push(
        MaterialPageRoute<void>(builder: (_) => const ScanCaptureScreen()),
      );
    }
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      goToHome(context);
      return;
    }

    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _resolvedImage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const _ReviewHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageProvider == null
                          ? Container(
                              color: const Color(0xFF242222),
                              alignment: Alignment.center,
                              child: const Text(
                                'Captured photo preview',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : Image(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'IMAGE QUALITY CHECK',
                    style: AppTextStyles.overline,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Is your test clearly visible?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const _ReviewInfoCard(
                    color: AppColors.pinkCard,
                    title: 'Before submitting',
                    body: 'The result window should be in focus, fully visible and free from glare.',
                  ),

                  const SizedBox(height: 12),

                  const _ReviewInfoCard(
                    color: AppColors.grayCard,
                    title: 'Check the reading window',
                    body: 'Only interpret a test at the time specified by the manufacturer.',
                  ),

                  const SizedBox(height: 12),

                  const _ReviewInfoCard(
                    color: AppColors.grayCard,
                    title: 'Need a better photo?',
                    body: 'Recapture the test if the image is blurred, cropped or poorly lit.',
                  ),

                  const SizedBox(height: 12),

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
                    'This prototype uses filename-based demo routing. It does not interpret the actual test image or provide a medical diagnosis.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: _handleNavigation,
      ),
    );
  }
}

// ------------------------------------------------------------
// HEADER
// ------------------------------------------------------------

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppGradients.header,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
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

              const Text('Review Photo', style: AppTextStyles.headerTitle),

              const SizedBox(height: 4),

              const Text(
                'Confirm image quality before scanning',
                style: AppTextStyles.headerSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// REVIEW INFORMATION CARD
// ------------------------------------------------------------

class _ReviewInfoCard extends StatelessWidget {
  final Color color;
  final String title;
  final String body;

  const _ReviewInfoCard({
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 6),
          Text(body, style: AppTextStyles.cardBody),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// BOTTOM NAVIGATION
// ------------------------------------------------------------

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.navBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(AppIcons.bottomNav.length, (index) {
              final selected = index == currentIndex;

              return InkResponse(
                onTap: () => onTap(index),
                radius: 28,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    AppIcons.bottomNav[index],
                    size: 26,
                    color: selected ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
