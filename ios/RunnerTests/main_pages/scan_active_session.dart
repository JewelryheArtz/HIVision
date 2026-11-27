import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../instruction/scan_navigation.dart';
import '../widgets/app_components.dart';
import 'scan_image_selected.dart';
import 'scan_saved_record.dart';

/// Scan · Active session screen (`lib/main_pages/scan_active_session.dart`).
/// Shows the test placement guide and capture/upload actions.
class ScanActiveSessionScreen extends StatefulWidget {
  const ScanActiveSessionScreen({
    super.key,
    this.initialSource,
    this.imagePicker,
  });

  final ImageSource? initialSource;
  final ImagePicker? imagePicker;

  @override
  State<ScanActiveSessionScreen> createState() =>
      _ScanActiveSessionScreenState();
}

class _ScanActiveSessionScreenState extends State<ScanActiveSessionScreen> {
  int _navIndex = 0;
  bool _isPickingImage = false;
  late final DateTime _sessionStartedAt;

  @override
  void initState() {
    super.initState();
    _sessionStartedAt = DateTime.now();
    final initialSource = widget.initialSource;
    if (initialSource != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectImage(initialSource);
      });
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _onNavTap(int index) {
    if (index == 0) {
      goToHome(context);
      return;
    }
    setState(() => _navIndex = index);
  }

  Future<void> _selectImage(ImageSource source) async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    try {
      final XFile? selectedImage = await (widget.imagePicker ?? ImagePicker())
          .pickImage(source: source, maxWidth: 1600, imageQuality: 85);

      if (selectedImage == null) return;

      final fileName = selectedImage.name;
      final normalizedName = fileName.toLowerCase();
      final isSupportedType = [
        '.jpg',
        '.jpeg',
        '.png',
      ].any(normalizedName.endsWith);

      if (!isSupportedType) {
        _showMessage('Please select a JPG or PNG image.');
        return;
      }

      final fileSize = await selectedImage.length();
      if (fileSize > 10 * 1024 * 1024) {
        _showMessage('Image exceeds the 10 MB limit. Choose a smaller image.');
        return;
      }

      final imageBytes = await selectedImage.readAsBytes();
      if (imageBytes.isEmpty) {
        _showMessage('The selected image is empty. Choose another image.');
        return;
      }

      if (imageBytes.lengthInBytes > 10 * 1024 * 1024) {
        _showMessage('Image exceeds the 10 MB limit. Choose a smaller image.');
        return;
      }

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ScanImageSelectedScreen(
            imageBytes: imageBytes,
            fileName: fileName,
            sourceLabel: source == ImageSource.camera
                ? 'Captured image'
                : 'Uploaded image',
            selectedAt: DateTime.now(),
          ),
        ),
      );
    } on PlatformException catch (error) {
      final sourceName = source == ImageSource.camera ? 'camera' : 'photos';
      _showMessage(
        'Could not open $sourceName: ${error.message ?? error.code}',
      );
    } on MissingPluginException {
      _showMessage(
        'Image selection is unavailable on this device. Try again after restarting the app.',
      );
    } on StateError {
      _showMessage('Unable to read the selected image. Please try another.');
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppGradientHeader(
            title: 'Scan your test',
            subtitle: 'New scan · Image not yet saved',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STEP 1 OF 2 · CAPTURE',
                    style: AppTextStyles.overline,
                  ),
                  const SizedBox(height: 14),

                  const _ActiveSessionCassetteCard(),
                  const SizedBox(height: 14),

                  // Guidance card: Keep the whole test in view
                  const _ActiveSessionInfoCard(
                    color: AppColors.grayCard,
                    title: 'Keep the whole test in view',
                    body: 'Hold steady and avoid glare. The preview above illustrates placement only.',
                  ),
                  const SizedBox(height: 12),

                  // Pink session status card: New scan session
                  _ActiveSessionInfoCard(
                    color: AppColors.pinkCard,
                    title: 'New scan session',
                    body:
                        '${formatScanTimestamp(_sessionStartedAt)}\n'
                        'A history record is added when the image is analyzed.',
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Take the photo within the reading time stated on your kit.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 12),

                  // Primary CTA: Capture image
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isPickingImage
                          ? null
                          : () => _selectImage(ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Capture image'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Secondary CTA: Upload from photos
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _isPickingImage
                          ? null
                          : () => _selectImage(ImageSource.gallery),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Upload from photos'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Camera access is used only to capture your test image. Demo session.',
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

class _ActiveSessionCassetteCard extends StatelessWidget {
  const _ActiveSessionCassetteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.grayCard,
        borderRadius: BorderRadius.circular(14),
      ),
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
                    border: Border.all(color: AppColors.border, width: 4),
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
    );
  }
}

class _ActiveSessionInfoCard extends StatelessWidget {
  final Color color;
  final String title;
  final String body;

  const _ActiveSessionInfoCard({
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
