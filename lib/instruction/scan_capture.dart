import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../main.dart';
import 'scan_review.dart';
import 'scan_navigation.dart';

class ScanCaptureScreen extends StatefulWidget {
  const ScanCaptureScreen({super.key, this.imagePicker});

  final ImagePicker? imagePicker;

  @override
  State<ScanCaptureScreen> createState() => _ScanCaptureScreenState();
}

class _ScanCaptureScreenState extends State<ScanCaptureScreen> {
  static const _maxImageBytes = 10 * 1024 * 1024;

  int _navIndex = 0;
  bool _isPickingImage = false;
  ImageProvider<Object>? _capturedImage;

  Future<void> _selectImage(ImageSource source) async {
    if (_isPickingImage) return;

    setState(() => _isPickingImage = true);

    try {
      final selectedImage = await (widget.imagePicker ?? ImagePicker())
          .pickImage(source: source);

      if (!mounted || selectedImage == null) return;

      final fileName = selectedImage.name.toLowerCase();

      final isSupportedType =
          fileName.endsWith('.jpg') ||
          fileName.endsWith('.jpeg') ||
          fileName.endsWith('.png');

      if (!isSupportedType) {
        _showPickerMessage('Choose a JPG or PNG image.');
        return;
      }

      final fileSize = await selectedImage.length();

      if (!mounted) return;

      if (fileSize > _maxImageBytes) {
        _showPickerMessage('Image must be 10 MB or smaller.');
        return;
      }

      final imageBytes = await selectedImage.readAsBytes();

      if (!mounted) return;

      final preview = MemoryImage(imageBytes);

      setState(() => _capturedImage = preview);

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ScanReviewScreen(
            capturedImage: preview,
            fileName: selectedImage.name,
          ),
        ),
      );
    } on PlatformException catch (error) {
      if (mounted) {
        final sourceName = source == ImageSource.camera ? 'camera' : 'photos';

        _showPickerMessage(
          'Could not open $sourceName: ${error.message ?? error.code}',
        );
      }
    } on StateError {
      if (mounted) {
        _showPickerMessage(
          'Camera capture is not supported on this device. Choose Upload from photos instead.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _showPickerMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const _CaptureHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _capturedImage == null
                          ? Container(
                              color: const Color(0xFF242222),
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.all(18),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Position the test here',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Keep the entire result window in view.\nAvoid glare and hold your device steady.',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Image(image: _capturedImage!, fit: BoxFit.cover),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Take the photo within the reading time stated on the kit.',
                      style: AppTextStyles.caption,
                    ),
                  ),

                  const SizedBox(height: 12),

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
                      child: Text(
                        _isPickingImage ? 'Opening...' : 'Capture image',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 8),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Supports JPG or PNG up to 10 MB.',
                      style: AppTextStyles.caption,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Camera access is used only to capture your test image.',
                      style: AppTextStyles.caption,
                    ),
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

class _CaptureHeader extends StatelessWidget {
  const _CaptureHeader();

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

              const Text('Scan your test', style: AppTextStyles.headerTitle),

              const SizedBox(height: 4),

              const Text(
                'Capture or upload a test image',
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
