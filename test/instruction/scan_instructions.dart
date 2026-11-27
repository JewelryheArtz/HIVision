import 'package:material_ui/material_ui.dart';

import '../main.dart';
import 'scan_capture.dart';
import 'scan_navigation.dart';

class ScanInstructionsScreen extends StatefulWidget {
  const ScanInstructionsScreen({super.key});

  @override
  State<ScanInstructionsScreen> createState() => _ScanInstructionsScreenState();
}

class _ScanInstructionsScreenState extends State<ScanInstructionsScreen> {
  int _navIndex = 0;

  void _openCamera() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ScanCaptureScreen()));
  }

  void _uploadTestImage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ScanCaptureScreen()));
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      goToHome(context);
      return;
    }

    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const _ScanHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BEFORE YOU START', style: AppTextStyles.overline),
                  const SizedBox(height: 12),

                  const Text(
                    'Follow your test kit\ninstructions.',
                    style: TextStyle(
                      fontSize: 24,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'For accurate guidance, scan your test within the reading window specified by your kit.',
                    style: AppTextStyles.cardBody,
                  ),
                  const SizedBox(height: 18),

                  const _StepCard(
                    stepNumber: '1',
                    title: 'Prepare the test',
                    body: 'Complete all steps in the manufacturer’s instructions.',
                  ),
                  const SizedBox(height: 12),

                  const _StepCard(
                    stepNumber: '2',
                    title: 'Use good lighting',
                    body: 'Place the test on a flat surface. Avoid glare, blur and shadows.',
                  ),
                  const SizedBox(height: 12),

                  const _StepCard(
                    stepNumber: '3',
                    title: 'Keep the result window visible',
                    body: 'Make sure the full test strip and control area are in the image.',
                  ),
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 14),

                  const Text(
                    'This feature gives image-based guidance, not a medical diagnosis.',
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

class _ScanHeader extends StatelessWidget {
  const _ScanHeader();

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

              const Text('HIV Self-Testing', style: AppTextStyles.headerTitle),
              const SizedBox(height: 4),

              const Text(
                'Before you scan',
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
// INSTRUCTION STEP CARD
// ------------------------------------------------------------

class _StepCard extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String body;

  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grayCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$stepNumber  $title', style: AppTextStyles.cardTitle),
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
