import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// =====================================================
// Shared colors
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
// Provider data
// -----------------------------------------------------
// Each entry below is one source card AND its details and redirection
// pages. To change the content, edit the text here. To use a real
// backend later, replace [kProvidersJson] with the list your API returns
// (same keys) and keep KitProvider.fromJson as it is.
// =====================================================
class KitProvider {
  // Source list card
  final String name;
  final String shortName;
  final String type;
  final String meta;
  final String detail;
  final String? price;
  final String? note;
  final bool recentlyViewed;

  // Details page
  final String kitName;
  final String kitInfo;
  final String productPrice;
  final String status;
  final String infoTitle;
  final String infoBody;
  final String checkTitle;
  final String checkBody;
  final String actionLabel;

  // Redirection page
  final String website;
  final String selectionNote;

  const KitProvider({
    required this.name,
    required this.shortName,
    required this.type,
    required this.meta,
    required this.detail,
    this.price,
    this.note,
    this.recentlyViewed = false,
    required this.kitName,
    required this.kitInfo,
    required this.productPrice,
    required this.status,
    required this.infoTitle,
    required this.infoBody,
    required this.checkTitle,
    required this.checkBody,
    required this.actionLabel,
    required this.website,
    required this.selectionNote,
  });

  factory KitProvider.fromJson(Map<String, dynamic> json) {
    return KitProvider(
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      type: json['type'] as String,
      meta: json['meta'] as String,
      detail: json['detail'] as String,
      price: json['price'] as String?,
      note: json['note'] as String?,
      recentlyViewed: (json['recentlyViewed'] as bool?) ?? false,
      kitName: json['kitName'] as String,
      kitInfo: json['kitInfo'] as String,
      productPrice: json['productPrice'] as String,
      status: json['status'] as String,
      infoTitle: json['infoTitle'] as String,
      infoBody: json['infoBody'] as String,
      checkTitle: json['checkTitle'] as String,
      checkBody: json['checkBody'] as String,
      actionLabel: json['actionLabel'] as String,
      website: json['website'] as String,
      selectionNote: json['selectionNote'] as String,
    );
  }
}

// Stand-in for the backend response. Replace with your API data later.
const List<Map<String, dynamic>> kProvidersJson = [
  {
    'name': 'CareLink Pharmacy',
    'shortName': 'CareLink',
    'type': 'Online pharmacy',
    'meta': 'Online pharmacy · Delivery available',
    'detail': 'HIV self-test kit',
    'price': '₱525.00',
    'note': 'Available · Ships in 2–4 business days',
    'recentlyViewed': true,
    'kitName': 'HIV self-test kit',
    'kitInfo': '1 kit · For home use',
    'productPrice': '₱525.00',
    'status': 'Available',
    'infoTitle': 'Delivery to Metro Manila',
    'infoBody':
        'Estimated arrival: 2–4 business days\nDelivery fee is shown at provider checkout.',
    'checkTitle': 'Check before ordering',
    'checkBody':
        'Confirm the pharmacy is licensed and the kit is registered with the Philippine FDA. Follow the kit instructions.',
    'actionLabel': 'See ordering options',
    'website': 'carelink.example',
    'selectionNote': 'Delivery: 2–4 business days · Fees at checkout',
  },
  {
    'name': 'Community Care Network',
    'shortName': 'Community Care Network',
    'type': 'Community organization',
    'meta': 'Community organization · Local pickup',
    'detail': 'Free kits, subject to eligibility',
    'kitName': 'HIV self-test kit',
    'kitInfo': '1 kit · For eligible clients',
    'productPrice': 'Free',
    'status': 'Eligibility applies',
    'infoTitle': 'Pickup in Metro Manila',
    'infoBody':
        'Pickup is arranged with the organization.\nAsk about hours and what to bring.',
    'checkTitle': 'Check before visiting',
    'checkBody':
        'Confirm eligibility, pickup hours and location with the organization before you go.',
    'actionLabel': 'See contact options',
    'website': 'communitycare.example',
    'selectionNote': 'Pickup: arranged with the organization',
  },
  {
    'name': 'Central Health Clinic',
    'shortName': 'Central Health Clinic',
    'type': 'Healthcare provider',
    'meta': 'Healthcare provider · 1.6 km away',
    'detail': 'From ₱350.00 · Ask about pickup',
    'kitName': 'HIV self-test kit',
    'kitInfo': '1 kit or in-person test',
    'productPrice': 'From ₱350.00',
    'status': 'Ask provider',
    'infoTitle': 'Pickup and visits',
    'infoBody':
        'Ask about kit pickup or in-person testing.\nHours and fees are set by the clinic.',
    'checkTitle': 'Check before visiting',
    'checkBody':
        'Confirm the clinic is licensed and offers testing. Ask about hours, privacy and fees.',
    'actionLabel': 'See contact options',
    'website': 'centralhealth.example',
    'selectionNote': 'Pickup or visit: arranged with the clinic',
  },
];

final List<KitProvider> kProviders =
    kProvidersJson.map(KitProvider.fromJson).toList();

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
          fontSize: 10,
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
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      );
}

class SubText extends StatelessWidget {
  final String text;
  const SubText(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
      );
}

class BodyNote extends StatelessWidget {
  final String text;
  const BodyNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          height: 1.45,
          color: AppColors.textMuted,
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
          fontSize: 10.5,
          height: 1.45,
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
      child: Column(
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
              fontSize: 11,
              height: 1.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Provider row used in the source list. Set [highlighted] for the
/// recently viewed one (pink fill, red border, optional [tag]).
class ProviderCard extends StatelessWidget {
  final bool highlighted;
  final String? tag;
  final String name;
  final String meta;
  final String detail;
  final String? price;
  final String? note;
  final VoidCallback onTap;

  const ProviderCard({
    super.key,
    this.highlighted = false,
    this.tag,
    required this.name,
    required this.meta,
    required this.detail,
    this.price,
    this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? AppColors.pinkCard : AppColors.grayCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: highlighted
            ? const BorderSide(color: AppColors.primary, width: 1.2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tag != null) ...[
                  Text(
                    tag!,
                    style: const TextStyle(
                      fontSize: 9.5,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        detail,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (price != null)
                      Text(
                        price!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                if (note != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    note!,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String text;
  const StatusPill(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF3D9D5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

/// Product summary card (name, quantity info, price and status).
class ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String status;

  const ProductCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.status,
  });

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
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              StatusPill(status),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Your selection" summary on the ordering screen.
class SelectionCard extends StatelessWidget {
  final String label;
  final String title;
  final String price;
  final String note;

  const SelectionCard({
    super.key,
    required this.label,
    required this.title,
    required this.price,
    required this.note,
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
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
          ),
        ],
      ),
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
