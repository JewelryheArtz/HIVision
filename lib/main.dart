import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'instruction/scan_instructions.dart';
import 'main_pages/home_with_activity.dart';

void main() => runApp(const MyApp());

/// Returns to HomeWithActivityScreen and clears the previous navigation stack.
/// Used by the bottom navigation Home icon.
void goToHomeWithActivity(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const HomeWithActivityScreen()),
    (route) => false,
  );
}

/// Returns to the main landing HomeScreen and clears the previous navigation stack.
/// Used by the explicit "Return to home" buttons on the scan result pages.
void goToMainLanding(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    (route) => false,
  );
}

/// Exact color codes from your initial Figma design.
class AppColors {
  static const redDark = Color(0xFF7A0000);
  static const redMid = Color(0xFFB00000);
  static const redLight = Color(0xFFD10A0A);
  static const primary = Color(0xFFB30000);
  static const pinkCard = Color(0xFFFFF0EE);
  static const grayCard = Color(0xFFF4F3F3);
  static const textDark = Color(0xFF111111);
  static const textMuted = Color(0xFF6B6B6B);
  static const border = Color(0xFFDDDDDD);
  static const navBorder = Color(0xFFEAEAEA);
  static const webBackdrop = Color(0xFFE9E9E9);
}

/// Shared header gradient, reuse on every page.
class AppGradients {
  static const header = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.redDark, AppColors.redMid, AppColors.redLight],
  );
}

/// Shared typography styles.
class AppTextStyles {
  static const overline = TextStyle(
    fontSize: 11,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const headerOverline = TextStyle(
    fontSize: 11,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );

  static const headerTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  static const headerSubtitle = TextStyle(fontSize: 12, color: Colors.white);

  static const pageTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static const sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const cardBody = TextStyle(
    fontSize: 12,
    height: 1.45,
    color: AppColors.textMuted,
  );

  static final button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const caption = TextStyle(
    fontSize: 11,
    height: 1.4,
    color: AppColors.textMuted,
  );

  static const input = TextStyle(fontSize: 13, color: AppColors.textDark);
}

/// Shared icons and bottom navigation icons.
class AppIcons {
  static const back = Icons.arrow_back;

  static const List<IconData> bottomNav = [
    LucideIcons.house,
    LucideIcons.mapPin,
    LucideIcons.pill,
    LucideIcons.messageCircle,
    LucideIcons.circleUser,
  ];
}

/// Global application theme.
/// Uses fontFamily instead of GoogleFonts.interTextTheme()
/// to avoid the TextTheme type conflict with material_ui.
final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: GoogleFonts.inter().fontFamily,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiVision',
      builder: (context, child) {
        return Container(
          color: AppColors.webBackdrop,
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: ClipRect(child: child),
          ),
        );
      },
      theme: appTheme,
      home: const HomeWithActivityScreen(),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  static const _features = [
    _Feature(
      title: 'Self-test scanner',
      subtitle: 'Scan a kit image and view result guidance',
      color: AppColors.pinkCard,
    ),
    _Feature(
      title: 'Facilities near me',
      subtitle: 'Find testing facilities and healthcare hubs',
    ),
    _Feature(
      title: 'Where to get test kits',
      subtitle: 'Explore available sources and providers',
    ),
    _Feature(
      title: 'Medication tracker',
      subtitle: 'Set reminders and record medication intake',
    ),
    _Feature(
      title: 'Medication assistant',
      subtitle: 'Ask about your schedule or log an intake',
    ),
    _Feature(
      title: 'Order a test kit',
      subtitle: 'Continue to an external ordering provider',
    ),
  ];

  void _openFacilities() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const FacilitiesScreen()));
  }

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ScanInstructionsScreen()),
    );
  }

  /// Handles bottom navigation.
  void _onNavigationTap(int index) {
    if (index == 0) {
      goToHomeWithActivity(context);
      return;
    }

    // Other tabs are assigned to another team member.
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR DAILY SUPPORT',
                    style: AppTextStyles.overline,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'How can I help today?',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose a feature to get started.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 14),

                  for (var i = 0; i < _features.length; i++) ...[
                    _FeatureCard(
                      feature: _features[i],
                      onTap: i == 0
                          ? _openScanner
                          : i == 1
                          ? _openFacilities
                          : null,
                    ),
                    if (i != _features.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}

// ============================================================
// FACILITIES SCREEN
// ============================================================

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  final _locationController = TextEditingController();

  int _navIndex = 1;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _showUnavailableMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _useCurrentLocation() {
    _showUnavailableMessage(
      'Location access is not available yet. Search for an area instead.',
    );
  }

  void _searchArea() {
    if (_locationController.text.trim().isEmpty) {
      _showUnavailableMessage('Enter a city, area or postal code.');
      return;
    }

    _showUnavailableMessage('Facility search is not connected yet.');
  }

  /// Handles bottom navigation.
  void _onNavigationTap(int index) {
    if (index == 0) {
      goToHomeWithActivity(context);
      return;
    }

    // Other tabs are assigned to another team member.
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _FacilitiesHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('FIND NEARBY CARE', style: AppTextStyles.overline),
                  const SizedBox(height: 14),
                  const Text(
                    'Choose how to search.',
                    style: AppTextStyles.pageTitle,
                  ),
                  const SizedBox(height: 18),

                  const _InfoCard(
                    color: AppColors.pinkCard,
                    title: 'Use your location',
                    body: 'Allow location access to find nearby testing facilities and healthcare hubs.',
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _useCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Use current location'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Your location is used to find services. You can search manually instead.',
                    style: AppTextStyles.caption,
                  ),

                  const SizedBox(height: 18),

                  const Text('Or enter a location', style: AppTextStyles.label),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _locationController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchArea(),
                    style: AppTextStyles.input,
                    decoration: InputDecoration(
                      hintText: 'City, area or postal code',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _searchArea,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text('Search this area'),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const _InfoCard(
                    color: AppColors.grayCard,
                    title: 'What you can find',
                    body: 'HIV testing, confirmatory testing and healthcare support. Availability varies by facility.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}

// ============================================================
// FEATURE MODEL
// ============================================================

class _Feature {
  final String title;
  final String subtitle;
  final Color color;

  const _Feature({
    required this.title,
    required this.subtitle,
    this.color = AppColors.grayCard,
  });
}

// ============================================================
// HOME HEADER
// ============================================================

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppGradients.header,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('HOME', style: AppTextStyles.headerOverline),
              SizedBox(height: 10),
              Text(
                'Your health companion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Testing, care and daily support',
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
// FACILITIES HEADER
// ============================================================

class _FacilitiesHeader extends StatelessWidget {
  const _FacilitiesHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppGradients.header,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    goToHomeWithActivity(context);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(AppIcons.back, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Home',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Facilities Near Me',
                style: AppTextStyles.headerTitle,
              ),
              const SizedBox(height: 4),
              const Text(
                'Find testing and care services',
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
// FEATURE CARD
// ============================================================

class _FeatureCard extends StatelessWidget {
  final _Feature feature;
  final VoidCallback? onTap;

  const _FeatureCard({required this.feature, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: feature.color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feature.title, style: AppTextStyles.cardTitle),
              const SizedBox(height: 6),
              Text(feature.subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INFORMATION CARD
// ============================================================

class _InfoCard extends StatelessWidget {
  final Color color;
  final String title;
  final String body;

  const _InfoCard({
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

// ============================================================
// BOTTOM NAVIGATION
// ============================================================

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
