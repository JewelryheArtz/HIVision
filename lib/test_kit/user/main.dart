import 'package:flutter/material.dart';

import 'common.dart';
import 'tksources.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facilities Near Me',
      // Shows the app in a phone-width frame when run on web/desktop.
      // On a real phone (width <= 430) it fills the screen as normal.
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
    // TODO: request location permission (e.g. geolocator) and search nearby.
  }

  void _searchArea() {
    final query = _locationController.text.trim();
    if (query.isEmpty) return;
    // TODO: search facilities by [query].
  }

  void _onNavTap(int i) {
    // Pill icon opens the "Where to Get Test Kits" flow.
    if (i == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SourcesScreen()),
      );
      return;
    }
    setState(() => _navIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            title: 'Facilities Near Me',
            subtitle: 'Find testing and care services',
            backLabel: 'Home',
            onBack: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('FIND NEARBY CARE'),
                  const SizedBox(height: 14),
                  const SectionTitle('Choose how to search.'),
                  const SizedBox(height: 18),
                  const InfoCard(
                    color: AppColors.pinkCard,
                    title: 'Use your location',
                    body:
                        'Allow location access to find nearby testing facilities and healthcare hubs.',
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Use current location',
                    onPressed: _useCurrentLocation,
                  ),
                  const SizedBox(height: 12),
                  const FootNote(
                    'Your location is used to find services. You can search manually instead.',
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
                  TextField(
                    controller: _locationController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchArea(),
                    style: const TextStyle(fontSize: 13),
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
                  SecondaryButton(
                    label: 'Search this area',
                    onPressed: _searchArea,
                  ),
                  const SizedBox(height: 18),
                  const InfoCard(
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
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}