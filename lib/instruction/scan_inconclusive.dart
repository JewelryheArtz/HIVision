import 'package:material_ui/material_ui.dart';

import '../main.dart';
import 'scan_capture.dart';
import 'scan_navigation.dart';

class ScanInconclusiveScreen extends StatefulWidget {
  const ScanInconclusiveScreen({super.key});

  @override
  State<ScanInconclusiveScreen> createState() => _ScanInconclusiveScreenState();
}

class _ScanInconclusiveScreenState extends State<ScanInconclusiveScreen> {
  int _navIndex = 0;

  // Redirects directly to the camera capture screen.
  void _retakePhoto() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ScanCaptureScreen()));
  }

  void _onNavTap(int index) {
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
      body: Column(
        children: [
          const _InconclusiveHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _InconclusiveSummaryCard(),

                  const SizedBox(height: 12),

                  const _InconclusiveInfoCard(
                    title: 'Try a clearer image',
                    body: 'Retake the photo with the full result window in focus. If the test itself is unclear, follow the kit instructions or contact a care provider.',
                  ),

                  const SizedBox(height: 12),

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

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      // Return to the main landing HomeScreen.
                      onPressed: () => goToMainLanding(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Return to home'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'This is informational guidance, not a diagnosis. Follow your kit’s instructions and seek professional medical advice.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _InconclusiveBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _InconclusiveHeader extends StatelessWidget {
  const _InconclusiveHeader();

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

              const Text('Test guidance', style: AppTextStyles.headerTitle),

              const SizedBox(height: 4),

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

// ============================================================
// INCONCLUSIVE SUMMARY CARD
// ============================================================

class _InconclusiveSummaryCard extends StatelessWidget {
  const _InconclusiveSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.pinkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INCONCLUSIVE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'I couldn’t interpret this image.',
            style: TextStyle(
              fontSize: 17,
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'The image could not be reliably interpreted. Do not treat this as a reactive or non-reactive result.',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INFORMATION CARD
// ============================================================

class _InconclusiveInfoCard extends StatelessWidget {
  final String title;
  final String body;

  const _InconclusiveInfoCard({required this.title, required this.body});

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
          Text(title, style: AppTextStyles.cardTitle),

          const SizedBox(height: 6),

          Text(body, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

// ============================================================
// BOTTOM NAVIGATION
// ============================================================

class _InconclusiveBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _InconclusiveBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

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
