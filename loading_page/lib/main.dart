import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class AppColors {
  static const primary = Color(0xFF8B0000);
  static const primaryDark = Color(0xFF5C0000);
  static const primaryBright = Color(0xFFC40000);
  static const pinkBg = Color(0xFFFCE8E8);
  static const pinkSoft = Color(0xFFF5D0D0);
  static const textDark = Color(0xFF1A1A1A);
  static const textMuted = Color(0xFF6B6B6B);
  static const textLight = Color(0xFF999999);
  static const logoDark = Color(0xFF630000);
  static const dotInactive = Color(0xFFD9D9D9);
  static const cardBorder = Color(0xFFC5CEDB);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HIVision',
      builder: (context, child) {
        return Container(
          color: const Color(0xFFE9E9E9),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: ClipRect(child: child),
          ),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoadingScreen(next: WelcomeScreen()),
    );
  }
}

class _Logo extends StatelessWidget {
  final double size;
  const _Logo({required this.size});

  @override
  Widget build(BuildContext context) {
    final height = size * 209 / 215;
    return Image.asset(
      'Hivision_logo.png',
      width: size,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) {
        debugPrint('Logo failed to load: $error');
        return SizedBox(
          width: size,
          height: height,
          child: Center(
            child: Container(
              width: size * 0.8,
              height: size * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 6),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Logo drawn in code so the lens blades can move
// ---------------------------------------------------------------------------

class _AnimatedLogo extends StatelessWidget {
  final double size;

  /// 0 = lens closed, 1 = lens fully open (matches the original logo).
  final Animation<double> opening;

  const _AnimatedLogo({required this.size, required this.opening});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1450 / 1427),
      painter: _LensLogoPainter(opening),
    );
  }
}

class _LensLogoPainter extends CustomPainter {
  final Animation<double> opening;
  _LensLogoPainter(this.opening) : super(repaint: opening);

  static const _center = Offset(908, 691);

  // Each lens blade: [point on the ring, curve control, inner end].
  static const _blades = [
    [Offset(955, 145), Offset(1125, 420), Offset(1130, 640)],
    [Offset(450, 372), Offset(690, 355), Offset(900, 430)],
    [Offset(362, 870), Offset(500, 610), Offset(760, 535)],
    [Offset(850, 1235), Offset(670, 1010), Offset(690, 740)],
    [Offset(1350, 1018), Offset(1080, 1035), Offset(850, 905)],
    [Offset(1432, 495), Offset(1300, 720), Offset(1100, 810)],
  ];

  static Path get _swoosh => Path()
    ..moveTo(460, 1015)
    ..cubicTo(540, 945, 690, 930, 790, 985)
    ..cubicTo(870, 1035, 900, 1105, 892, 1170)
    ..cubicTo(885, 1250, 855, 1290, 855, 1360)
    ..cubicTo(858, 1440, 930, 1510, 1020, 1498)
    ..cubicTo(930, 1550, 820, 1540, 755, 1480)
    ..cubicTo(690, 1415, 700, 1320, 705, 1260)
    ..cubicTo(715, 1200, 725, 1170, 718, 1130)
    ..cubicTo(680, 1060, 540, 1050, 465, 1125)
    ..close();

  static Path get _leftStroke => Path()
    ..moveTo(105, 1525)
    ..cubicTo(190, 1540, 285, 1495, 320, 1420)
    ..cubicTo(370, 1310, 400, 1190, 465, 1125)
    ..cubicTo(540, 1065, 640, 1070, 718, 1130)
    ..cubicTo(715, 1040, 590, 990, 465, 1015)
    ..cubicTo(510, 910, 555, 770, 595, 640)
    ..cubicTo(530, 625, 465, 650, 420, 705)
    ..cubicTo(390, 745, 370, 810, 340, 890)
    ..lineTo(105, 1525)
    ..close();

  static Path get _rightStroke => Path()
    ..moveTo(1495, 628)
    ..lineTo(1300, 1060)
    ..cubicTo(1245, 1180, 1205, 1245, 1180, 1300)
    ..cubicTo(1135, 1400, 1075, 1458, 990, 1458)
    ..cubicTo(925, 1458, 888, 1405, 892, 1335)
    ..cubicTo(915, 1372, 960, 1378, 985, 1330)
    ..cubicTo(1015, 1275, 1030, 1240, 1070, 1160)
    ..lineTo(1275, 730)
    ..cubicTo(1320, 660, 1400, 630, 1495, 628)
    ..close();

  static Path get _drop => Path()
    ..moveTo(928, 215)
    ..cubicTo(975, 330, 1055, 430, 1105, 505)
    ..cubicTo(1155, 580, 1185, 630, 1185, 700)
    ..cubicTo(1185, 835, 1070, 940, 930, 940)
    ..cubicTo(790, 940, 675, 840, 675, 700)
    ..cubicTo(675, 620, 715, 560, 770, 490)
    ..cubicTo(840, 400, 895, 310, 928, 215)
    ..close();

  static Path get _dropInner => Path()
    ..moveTo(932, 235)
    ..cubicTo(975, 330, 1055, 430, 1105, 505)
    ..cubicTo(1155, 580, 1185, 630, 1185, 700)
    ..cubicTo(1175, 800, 1080, 885, 960, 885)
    ..cubicTo(850, 885, 772, 790, 772, 660)
    ..cubicTo(772, 540, 870, 390, 932, 235)
    ..close();

  static Path get _shine1 => Path()
    ..moveTo(1028, 508)
    ..cubicTo(1055, 515, 1075, 540, 1080, 570)
    ..cubicTo(1065, 550, 1045, 530, 1028, 508)
    ..close();

  static Path get _shine2 => Path()
    ..moveTo(1116, 678)
    ..cubicTo(1132, 705, 1125, 745, 1100, 775)
    ..cubicTo(1110, 745, 1115, 710, 1116, 678)
    ..close();

  static Path get _crease => Path()
    ..moveTo(1062, 562)
    ..cubicTo(1135, 640, 1135, 750, 1050, 815);

  @override
  void paint(Canvas canvas, Size size) {
    final t = opening.value;
    Paint fill(Color color) => Paint()..color = color;
    Paint line(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.scale(size.width / 1427);
    canvas.translate(-105, -88);

    // 1. Lens blades: they untwist and swing open.
    canvas.save();
    canvas.clipPath(Path()
      ..addOval(
          Rect.fromCenter(center: _center, width: 1160, height: 1130)));
    canvas.translate(_center.dx, _center.dy);
    canvas.rotate(-(1 - t) * 2 * pi / 3);
    canvas.translate(-_center.dx, -_center.dy);
    for (final blade in _blades) {
      final start = blade[0];
      final control =
          Offset.lerp((start + _center) / 2, blade[1], t)!;
      final end = Offset.lerp(_center, blade[2], t)!;
      canvas.drawPath(
        Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy),
        line(AppColors.primary, 32),
      );
    }
    canvas.restore();

    // 2. Lens ring.
    final ring = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(Rect.fromLTRB(283, 88, 1533, 1296))
      ..addOval(Rect.fromLTRB(352, 150, 1464, 1232));
    canvas.drawPath(ring, fill(AppColors.primary));

    // 3. Letters and blood drop, on top of the lens.
    canvas.drawPath(_swoosh, fill(AppColors.primary));
    canvas.drawPath(_leftStroke, fill(AppColors.logoDark));
    canvas.drawPath(_rightStroke, fill(AppColors.logoDark));
    canvas.drawPath(_drop, fill(AppColors.logoDark));
    canvas.drawPath(_dropInner, fill(AppColors.primary));
    canvas.drawPath(_shine1, fill(Colors.white));
    canvas.drawPath(_shine2, fill(Colors.white));
    canvas.drawPath(_crease, line(AppColors.logoDark, 12));

    canvas.restore();
  }

  @override
  bool shouldRepaint(_LensLogoPainter oldDelegate) =>
      oldDelegate.opening != opening;
}

// ---------------------------------------------------------------------------
// Loading screen (used at app start AND before the homepage)
// ---------------------------------------------------------------------------

class LoadingScreen extends StatefulWidget {
  /// The screen to open once loading finishes.
  final Widget next;
  const LoadingScreen({super.key, required this.next});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );
  late final Animation<double> _bar =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  late final Animation<double> _shutter = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.1, 0.85, curve: Curves.easeInOutCubic),
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.next),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            _AnimatedLogo(size: 130, opening: _shutter),
            const SizedBox(height: 18),
            const Text(
              'HIVision',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your test. Your privacy. Your pace.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.textMuted,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                children: [
                  SizedBox(
                    height: 3,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: AnimatedBuilder(
                        animation: _bar,
                        builder: (context, _) => Stack(
                          children: [
                            Container(height: 3, color: AppColors.dotInactive),
                            FractionallySizedBox(
                              widthFactor: _bar.value,
                              child: Container(
                                  height: 3, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Loading...',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 36),
              const _Logo(size: 150),
              const SizedBox(height: 14),
              const Text('HIVision',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              const SizedBox(height: 40),
              const Text(
                'Access discreet self-testing guidance and daily support',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    height: 1.25),
              ),
              const SizedBox(height: 16),
              const Text(
                'Result guidance, care referrals and treatment support. '
                'No registration needed to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, height: 1.5, color: AppColors.textMuted),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OnboardingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Get started'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Designed with the Data Privacy Act of 2012 and RA 11166 in mind.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textLight),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Ill { readResult, findCare, testKit, treatment, chat }

class _Page {
  final String title;
  final String description;
  final List<String> bullets;
  final _Ill ill;
  final String footer;
  final bool isLast;
  const _Page({
    required this.title,
    required this.description,
    required this.bullets,
    required this.ill,
    required this.footer,
    required this.isLast,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _current = 0;

  static const _pages = [
    _Page(
      title: 'Read your result, privately',
      description:
          'Your phone reads the test strip on the device itself. Your photo is never sent to a server.',
      bullets: [
        'Result: reactive, non-reactive, invalid or inconclusive',
        'Retake prompts when light or image is unclear',
        'Helps connect you to nearby care and support after your test.',
      ],
      ill: _Ill.readResult,
      footer: 'Automated reading is not a diagnosis.',
      isLast: false,
    ),
    _Page(
      title: 'Find care near you',
      description:
          'Find verified testing sites, barangay health centers and NGO hubs around you.',
      bullets: [
        'Anonymous testing facilities on a map',
        'Places that offer free self-test kits',
        'Services and details before you go',
      ],
      ill: _Ill.findCare,
      footer: 'Contact the facility to confirm hours.',
      isLast: false,
    ),
    _Page(
      title: 'Get a test kit',
      description:
          'Browse verified online pharmacies or find out where to get free kits.',
      bullets: [
        'Links to verified online pharmacies',
        'Free kit sources from NGOs and health centers',
        'No health records shared when you order',
      ],
      ill: _Ill.testKit,
      footer: 'Ordering happens on the provider site.',
      isLast: false,
    ),
    _Page(
      title: 'Stay on track with treatment',
      description:
          'For people on antiretroviral therapy: schedules, reminders and dose logging in one place.',
      bullets: [
        'Enter your medicine, dates and times',
        'Gentle reminders that avoid alert fatigue',
        'See your adherence history',
      ],
      ill: _Ill.treatment,
      footer: 'Follow the treatment plan from your healthcare provider.',
      isLast: false,
    ),
    _Page(
      title: 'Ask, track, and navigate privately',
      description:
          'Chat in your own words to get general HIV info, set medication reminders, or jump straight to the tool you need.',
      bullets: [
        'Plain-language answers about HIV and testing',
        'Quick pill reminders and dose logging',
        'Easy navigation across all app features, kept on-device',
      ],
      ill: _Ill.chat,
      footer: 'Core features work without an account.',
      isLast: true,
    ),
  ];

  void _next() {
    if (_current < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToHome();
    }
  }

  // Shows the loading screen, then the homepage.
  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoadingScreen(next: HomeScreen()),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _goToHome,
                child: const Text('Skip',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, i) => _PageView(page: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final active = i == _current;
                      return Container(
                        width: active ? 18 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary
                              : AppColors.dotInactive,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      child:
                          Text(_pages[_current].isLast ? "I'm ready" : 'Next'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_pages[_current].footer,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  final _Page page;
  const _PageView({required this.page});

  static const _illustrationFiles = {
    _Ill.readResult: 'Frame 26.png',
    _Ill.findCare: 'Frame 27.png',
    _Ill.testKit: 'Frame 28.png',
    _Ill.treatment: 'Frame 32.png',
    _Ill.chat: 'Frame 29.png',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pink rounded card with the illustration centered on it.
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.pinkBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                _illustrationFiles[page.ill]!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) {
                  debugPrint(
                      'Illustration failed: ${_illustrationFiles[page.ill]} - $error');
                  return const Center(
                    child: Text('Illustration missing',
                        style: TextStyle(color: AppColors.textMuted)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(page.title,
              style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.2)),
          const SizedBox(height: 10),
          Text(page.description,
              style: const TextStyle(
                  fontSize: 13, height: 1.5, color: AppColors.textMuted)),
          const SizedBox(height: 14),
          for (final bullet in page.bullets) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: SizedBox(
                    width: 6,
                    height: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(bullet,
                      style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: AppColors.textMuted)),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Homepage
// ---------------------------------------------------------------------------

// Created once per app launch, so the guest number stays the same while open.
final int _guestNumber = 100 + Random().nextInt(900);

const _redGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    AppColors.primaryDark,
    AppColors.primary,
    AppColors.primaryBright,
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // White status bar icons on top of the red header.
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const _HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(40, 28, 40, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            title: 'Camera/Scan',
                            subtitle: 'Scan a result or label',
                            image: 'camera.png',
                            fallbackIcon: Icons.photo_camera,
                            onTap: () => _comingSoon(context, 'Camera/Scan'),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: _FeatureCard(
                            title: 'Map',
                            subtitle: 'Find facilities',
                            image: 'map.png',
                            fallbackIcon: Icons.location_on,
                            onTap: () => _comingSoon(context, 'Map'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            title: 'Test Kit',
                            subtitle: 'Where to get one?',
                            image: 'testkit.png',
                            fallbackIcon: Icons.medical_services,
                            onTap: () => _comingSoon(context, 'Test Kit'),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: _FeatureCard(
                            title: 'Medication Tracker',
                            subtitle: 'Doses and reminders',
                            image: 'medication.png',
                            fallbackIcon: Icons.medication,
                            onTap: () =>
                                _comingSoon(context, 'Medication Tracker'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    _AssistanceButton(
                      onTap: () => _comingSoon(context, 'Assistance'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const _HomeBottomBar(),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, topInset + 34, 22, 28),
      decoration: const BoxDecoration(
        gradient: _redGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Greetings,',
              style: TextStyle(fontSize: 15, color: Colors.white)),
          const SizedBox(height: 2),
          Text('Guest - $_guestNumber',
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final IconData fallbackIcon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.fallbackIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      child: Material(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stack) => Icon(
                          fallbackIcon,
                          size: 52,
                          color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10.5, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssistanceButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AssistanceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: 52,
        decoration: BoxDecoration(
          gradient: _redGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text('Need assistance?',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBottomBar extends StatelessWidget {
  const _HomeBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Center(
            child: IconButton.outlined(
              onPressed: () {/* Already on the homepage */},
              tooltip: 'Home',
              iconSize: 28,
              padding: const EdgeInsets.all(12),
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
              ),
              color: AppColors.primary,
              icon: const Icon(Icons.home_outlined),
            ),
          ),
        ),
      ),
    );
  }
}