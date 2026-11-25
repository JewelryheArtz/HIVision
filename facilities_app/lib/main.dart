import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() => runApp(const MyApp());

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

// Shared sizing so every field/button is identical across screens.
class AppSizes {
  static const fieldHeight = 48.0;
  static const fieldRadius = 10.0;
  static const fieldPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facilities Near Me',
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
      home: const FacilitiesScreen(),
    );
  }
}

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

  void _useCurrentLocation() {
    // TODO: request location permission (e.g. geolocator) before navigating.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NearbyFacilitiesScreen()),
    );
  }

  void _searchArea() {
    final query = _locationController.text.trim();
    if (query.isEmpty) return;
    // TODO: search facilities by [query].
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _Header(
            title: 'Facilities Near Me',
            subtitle: 'Find testing and care services',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FIND NEARBY CARE',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Choose how to search.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _InfoCard(
                    color: AppColors.pinkCard,
                    title: 'Use your location',
                    body:
                        'Allow location access to find nearby testing facilities and healthcare hubs.',
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.fieldHeight,
                    child: ElevatedButton(
                      onPressed: _useCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Use current location'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your location is used to find services. You can search manually instead.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Or enter a location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Fixed height so it matches every other field in the app.
                  SizedBox(
                    height: AppSizes.fieldHeight,
                    child: TextField(
                      controller: _locationController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchArea(),
                      style: const TextStyle(fontSize: 13),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'City, area or postal code',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        contentPadding: AppSizes.fieldPadding,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.fieldHeight,
                    child: OutlinedButton(
                      onPressed: _searchArea,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Search this area'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _InfoCard(
                    color: AppColors.grayCard,
                    title: 'What you can find',
                    body:
                        'HIV testing, confirmatory testing and healthcare support. Availability varies by facility.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

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
                onTap: () => Navigator.maybePop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

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
                onTap: () => onTap(i),
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


// ---------------------------------------------------------------------------
// Nearby facilities screen (opens when "Use current location" is tapped).
// Tapping a facility card switches it to the populated map view.
// ---------------------------------------------------------------------------

class _Facility {
  final String name;
  final String services;
  final String note;
  final String address;
  final String hours;
  final String distance;
  final List<String> serviceItems;
  const _Facility({
    required this.name,
    required this.services,
    required this.note,
    required this.address,
    required this.hours,
    required this.distance,
    required this.serviceItems,
  });
}

const _sampleFacilities = [
  _Facility(
    name: 'Community testing center',
    services: 'HIV testing \u2022 Counseling',
    note: 'View services, contact details and directions',
    address: '24 Wellness St, Central district',
    hours: 'Mon-Fri, 8:00 AM-5:00 PM',
    distance: '0.8 km',
    serviceItems: [
      'HIV testing',
      'Confirmatory testing referrals',
      'Counseling and care support',
    ],
  ),
  _Facility(
    name: 'Community healthcare hub',
    services: 'Care support \u2022 Referrals',
    note: 'Contact the facility to confirm availability',
    address: 'Community Ave, Central district',
    hours: 'Mon-Sat, 9:00 AM-6:00 PM',
    distance: '1.6 km',
    serviceItems: [
      'Care support',
      'Referrals',
      'Counseling and care support',
    ],
  ),
];

class NearbyFacilitiesScreen extends StatefulWidget {
  final String query;
  const NearbyFacilitiesScreen({super.key, this.query = ''});

  @override
  State<NearbyFacilitiesScreen> createState() => _NearbyFacilitiesScreenState();
}

class _NearbyFacilitiesScreenState extends State<NearbyFacilitiesScreen> {
  late final TextEditingController _controller;
  bool _mapView = true;
  bool _populated = false;
  int _selected = -1; // Changed from 0 to -1 so nothing is selected by default
  int _navIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectFacility(int i) {
    setState(() {
      _selected = i;
      _populated = true;
    });
  }

  void _openFacilityInfo() {
    if (_selected < 0) return; // Guard: do nothing if nothing is selected
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FacilityInfoScreen(
          facility: _sampleFacilities[_selected],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _Header(
            title: 'Nearby facilities',
            subtitle: _populated
                ? 'Find testing, counseling and care near you'
                : 'Explore available care options',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _populated ? _populatedBody() : _defaultBody(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.fieldHeight,
              child: ElevatedButton(
                // Button is only enabled when _selected >= 0
                onPressed: _selected >= 0 ? _openFacilityInfo : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  disabledBackgroundColor: AppColors.textMuted.withOpacity(0.3),
                  disabledForegroundColor: Colors.white.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('View selected facility'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  // ---- State 1: before a facility is tapped -------------------------------
  List<Widget> _defaultBody() {
    return [
      const _FieldLabel('Search area'),
      const SizedBox(height: 10),
      SizedBox(
        height: AppSizes.fieldHeight,
        child: TextField(
          controller: _controller,
          style: const TextStyle(fontSize: 13),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Sample area',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            contentPadding: AppSizes.fieldPadding,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
          ),
        ),
      ),
      const SizedBox(height: 14),
      _MapListToggle(
        mapView: _mapView,
        onChanged: (v) => setState(() => _mapView = v),
      ),
      const SizedBox(height: 14),
      if (_mapView) ...[
        const _MapPlaceholder(),
        const SizedBox(height: 12),
      ],
      const Text(
        'SAMPLE FACILITIES \u2022 Replace with local service data',
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 0.3,
          color: AppColors.textMuted,
        ),
      ),
      const SizedBox(height: 12),
      for (int i = 0; i < _sampleFacilities.length; i++) ...[
        _FacilityCard(
          facility: _sampleFacilities[i],
          selected: i == _selected,
          detailed: false,
          onTap: () => _selectFacility(i),
        ),
        const SizedBox(height: 10),
      ],
    ];
  }

  // ---- State 2: populated map (after tapping a facility) -------------------
  List<Widget> _populatedBody() {
    return [
      const _FieldLabel('Search area'),
      const SizedBox(height: 10),
      Container(
        height: AppSizes.fieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.mapPin, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Central district',
                style: TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
            ),
            InkWell(
              onTap: () => setState(() => _populated = false),
              child: const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          _MapListToggle(
            mapView: _mapView,
            onChanged: (v) => setState(() => _mapView = v),
          ),
          const Spacer(),
          const Text(
            'Within 5 km',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
      const SizedBox(height: 14),
      if (_mapView) ...[
        const _PopulatedMap(),
        const SizedBox(height: 16),
      ],
      Row(
        children: [
          Text(
            '${_sampleFacilities.length} facilities nearby',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          const Text(
            'Nearest first',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
      const SizedBox(height: 12),
      for (int i = 0; i < _sampleFacilities.length; i++) ...[
        _FacilityCard(
          facility: _sampleFacilities[i],
          selected: i == _selected,
          detailed: true,
          onTap: () => _selectFacility(i),
        ),
        const SizedBox(height: 10),
      ],
    ];
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

class _MapListToggle extends StatelessWidget {
  final bool mapView;
  final ValueChanged<bool> onChanged;

  const _MapListToggle({required this.mapView, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.grayCard,
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            label: 'Map view',
            selected: mapView,
            onTap: () => onChanged(true),
          ),
          _Segment(
            label: 'List view',
            selected: !mapView,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.border : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final _Facility facility;
  final bool selected;
  final bool detailed;
  final VoidCallback onTap;

  const _FacilityCard({
    required this.facility,
    required this.selected,
    required this.detailed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const muted = TextStyle(fontSize: 12, height: 1.45, color: AppColors.textMuted);

    final Widget content;
    if (!detailed) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            facility.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(facility.services, style: muted),
          Text(facility.note, style: muted),
        ],
      );
    } else if (selected) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  facility.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                facility.distance,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(facility.address, style: muted),
          const SizedBox(height: 4),
          Text(facility.services, style: muted),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text(facility.hours, style: muted)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Selected',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  facility.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                facility.distance,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(facility.services, style: muted),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.pinkCard : AppColors.grayCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected && detailed ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: content,
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  static const _blockColor = Color(0xFFEFEBE8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;

          Widget block(double l, double t, double bw, double bh) {
            return Positioned(
              left: w * l,
              top: h * t,
              width: w * bw,
              height: h * bh,
              child: Container(
                decoration: BoxDecoration(
                  color: _blockColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }

          return Stack(
            children: [
              block(0.00, 0.00, 0.19, 0.28),
              block(0.23, 0.00, 0.44, 0.28),
              block(0.71, 0.00, 0.29, 0.28),
              block(0.00, 0.33, 0.19, 0.34),
              block(0.23, 0.33, 0.44, 0.34),
              block(0.71, 0.33, 0.29, 0.34),
              block(0.00, 0.72, 0.67, 0.28),
              block(0.71, 0.72, 0.29, 0.28),
              Positioned(
                left: w * 0.33,
                top: h * 0.30,
                child: const Icon(
                  LucideIcons.mapPin,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                left: w * 0.84,
                top: h * 0.40,
                child: const Icon(
                  LucideIcons.mapPin,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                left: 8,
                bottom: 6,
                child: Text(
                  'Illustrative map \u2022 sample locations',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.textMuted.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PopulatedMap extends StatelessWidget {
  const _PopulatedMap();

  static const _bg = Color(0xFFF6F4F1);
  static const _tile = Color(0xFFECE8E3);
  static const _park = Color(0xFFDDE9D5);
  static const _you = Color(0xFF2F6FDE);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;

            Widget tile(double l, double t, double bw, double bh,
                {Color color = _tile, Widget? child}) {
              return Positioned(
                left: w * l,
                top: h * t,
                width: w * bw,
                height: h * bh,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: child,
                ),
              );
            }

            Widget label(String text, double l, double t) {
              return Positioned(
                left: w * l,
                top: h * t,
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.textMuted,
                  ),
                ),
              );
            }

            Widget pin({
              required double l,
              required double t,
              required String count,
              required String text,
              required bool highlighted,
            }) {
              return Positioned(
                left: w * l,
                top: h * t,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.mapPin,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: highlighted ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: highlighted
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        '$count  $text',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color:
                              highlighted ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                Positioned.fill(child: Container(color: _bg)),
                tile(0.02, 0.04, 0.20, 0.40),
                tile(0.02, 0.50, 0.20, 0.46),
                tile(0.27, 0.04, 0.48, 0.28),
                tile(0.27, 0.38, 0.48, 0.26),
                tile(0.27, 0.70, 0.48, 0.26),
                tile(0.80, 0.04, 0.18, 0.24),
                tile(
                  0.80,
                  0.34,
                  0.18,
                  0.30,
                  color: _park,
                  child: const Text(
                    'Park.',
                    style: TextStyle(fontSize: 8, color: AppColors.textMuted),
                  ),
                ),
                tile(0.80, 0.70, 0.18, 0.26),
                label('Wellness St', 0.30, 0.34),
                label('Community Ave', 0.30, 0.66),
                pin(
                  l: 0.08,
                  t: 0.10,
                  count: '2',
                  text: 'Healthcare hub',
                  highlighted: false,
                ),
                pin(
                  l: 0.30,
                  t: 0.42,
                  count: '1',
                  text: 'Testing center',
                  highlighted: true,
                ),
                Positioned(
                  left: w * 0.66,
                  top: h * 0.76,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: _you,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'You',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  left: 8,
                  bottom: 4,
                  child: Text(
                    'Illustrative map',
                    style: TextStyle(fontSize: 8, color: AppColors.textMuted),
                  ),
                ),
                Positioned(
                  left: w * 0.34,
                  bottom: 4,
                  child: const Text(
                    'Example facility data',
                    style: TextStyle(fontSize: 8, color: AppColors.textMuted),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// Facility information screen (opens when "View selected facility" is tapped).
// ---------------------------------------------------------------------------

class FacilityInfoScreen extends StatefulWidget {
  final _Facility facility;

  const FacilityInfoScreen({super.key, required this.facility});

  @override
  State<FacilityInfoScreen> createState() => _FacilityInfoScreenState();
}

class _FacilityInfoScreenState extends State<FacilityInfoScreen> {
  int _navIndex = 1;

  @override
  Widget build(BuildContext context) {
    final f = widget.facility;

    return Scaffold(
      body: Column(
        children: [
          const _Header(
            title: 'Facility information',
            subtitle: 'Services and visiting information',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SAMPLE FACILITY',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    f.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Illustrative listing \u2014 not a verified provider.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
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
                          'Services',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final service in f.serviceItems)
                          Text(
                            service,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  const _InfoCard(
                    color: AppColors.grayCard,
                    title: 'Before your visit',
                    body:
                        'Contact the facility to confirm hours, appointment requirements, service availability and fees.',
                  ),
                  const SizedBox(height: 18),

                  const _FieldLabel('Address'),
                  const SizedBox(height: 8),
                  const _PlaceholderBox(
                    text: 'Provider address will appear here',
                  ),
                  const SizedBox(height: 16),

                  const _FieldLabel('Contact'),
                  const SizedBox(height: 8),
                  const _PlaceholderBox(
                    text: 'Provider contact details will appear here',
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.fieldHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: open directions/maps for f.address.
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Get directions'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.fieldHeight,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Return to facilities'),
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
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  final String text;

  const _PlaceholderBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.fieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
      ),
    );
  }
}
