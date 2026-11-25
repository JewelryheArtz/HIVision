import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// =====================================================
// Shared colors (from main.dart)
// =====================================================
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
}

// =====================================================
// Header with gradient, back button, title and subtitle
// =====================================================
class GradientHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String backLabel;
  final VoidCallback onBack;

  const GradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.backLabel = 'Back',
  });

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
                onTap: onBack,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      backLabel,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// Text helpers
// =====================================================
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
        ),
      );
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      );
}

class FootNote extends StatelessWidget {
  final String text;
  const FootNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          height: 1.4,
          color: AppColors.textMuted,
        ),
      );
}

// =====================================================
// Cards
// =====================================================
class InfoCard extends StatelessWidget {
  final Color color;
  final String title;
  final String body;

  const InfoCard({
    super.key,
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
      child: _CardText(title: title, body: body),
    );
  }
}

class SourceCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SourceCard({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: double.infinity,
            child: _CardText(title: title, body: subtitle),
          ),
        ),
      ),
    );
  }
}

class _CardText extends StatelessWidget {
  final String title;
  final String body;
  const _CardText({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: const TextStyle(
            fontSize: 12,
            height: 1.45,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// =====================================================
// Buttons
// =====================================================
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const SecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
  }
}

// =====================================================
// Bottom navigation (Lucide icons)
// 0 home, 1 map pin, 2 bandage, 3 chat, 4 profile
// =====================================================
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNav({super.key, this.currentIndex = 0, this.onTap});

  static const _icons = [
    LucideIcons.house,
    LucideIcons.mapPin,
    LucideIcons.pill,
    LucideIcons.messageCircle,
    LucideIcons.circleUser,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (i) {
              final selected = i == currentIndex;
              return InkResponse(
                onTap: onTap == null ? null : () => onTap!(i),
                radius: 28,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _icons[i],
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
// =====================================================
// Test kit sources (one entry per card; edit text here)
// =====================================================
// Content for each test kit source. Add or edit entries here and the
// sources list, details and redirection screens update automatically.
class KitSource {
  final String name;
  final String cardSubtitle;

  // Details screen
  final String sectionLabel;
  final String checkTitle;
  final String checkBody;
  final String infoBody;
  final String expectBody;
  final String actionLabel;

  // Redirection screen
  final String redirectTitle;
  final String redirectBody;

  const KitSource({
    required this.name,
    required this.cardSubtitle,
    required this.sectionLabel,
    required this.checkTitle,
    required this.checkBody,
    required this.infoBody,
    required this.expectBody,
    required this.actionLabel,
    required this.redirectTitle,
    required this.redirectBody,
  });
}

const List<KitSource> kSources = [
  KitSource(
    name: 'Online pharmacy',
    cardSubtitle: 'Order a self-test kit and get it delivered.',
    sectionLabel: 'EXAMPLE SOURCE',
    checkTitle: 'Before you order',
    checkBody:
        'Make sure the pharmacy is licensed and the kit is authorized in your area.',
    infoBody:
        'Kit: HIV self-test\nStock: Check the provider’s website\nPrice and delivery: Set by the provider',
    expectBody:
        'You order and pay outside this app. Read the provider’s privacy and return policies first.',
    actionLabel: 'Go to ordering',
    redirectTitle: 'You’re leaving the app',
    redirectBody:
        'The pharmacy’s website will open. Choose your kit, delivery option and payment there.',
  ),
  KitSource(
    name: 'Community organization',
    cardSubtitle: 'Pick up a kit and get support nearby.',
    sectionLabel: 'EXAMPLE SOURCE',
    checkTitle: 'Before you visit',
    checkBody:
        'Confirm the organization’s hours, location and who qualifies for free kits.',
    infoBody:
        'Kit: HIV self-test\nStock: Confirm with the organization\nCost: May be free if you’re eligible',
    expectBody:
        'You may get a kit in person or by pickup. Staff can show you how to use it and where to find support.',
    actionLabel: 'See contact options',
    redirectTitle: 'You’re leaving the app',
    redirectBody:
        'The organization’s website or contact page will open. Check kit access, hours and eligibility there.',
  ),
  KitSource(
    name: 'Healthcare provider',
    cardSubtitle: 'Get a kit or test in person.',
    sectionLabel: 'EXAMPLE SOURCE',
    checkTitle: 'Before you visit',
    checkBody:
        'Confirm the clinic is licensed and offers testing. Ask about hours, privacy and fees.',
    infoBody:
        'Kit: HIV self-test or in-person test\nStock: Confirm with the provider\nCost: Set by the provider',
    expectBody:
        'Staff explain how testing works, answer your questions and point you to follow-up care.',
    actionLabel: 'See contact options',
    redirectTitle: 'You’re leaving the app',
    redirectBody:
        'The provider’s website or contact page will open. Ask about self-test kits and in-person testing there.',
  ),
];