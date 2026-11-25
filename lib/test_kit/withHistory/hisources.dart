import 'package:flutter/material.dart';

import 'common.dart';
import 'hisdetails.dart';

// SCREEN 1: Where to Get Test Kits (existing data)
class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  void _openDetails(BuildContext context, KitProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SourceDetailsScreen(provider: provider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The recently viewed provider is the one the main button opens.
    final featured = kProviders.firstWhere(
      (p) => p.recentlyViewed,
      orElse: () => kProviders.first,
    );

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          GradientHeader(
            title: 'Where to Get Test Kits',
            subtitle: 'Explore testing kit sources',
            backLabel: 'Home',
            onBack: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Your test kit sources'),
                  const SizedBox(height: 6),
                  SubText('${kProviders.length} sources serving Metro Manila'),
                  const SizedBox(height: 16),
                  for (final p in kProviders) ...[
                    if (p != kProviders.first) const SizedBox(height: 12),
                    ProviderCard(
                      highlighted: p.recentlyViewed,
                      tag: p.recentlyViewed ? 'RECENTLY VIEWED' : null,
                      name: p.name,
                      meta: p.meta,
                      detail: p.detail,
                      price: p.price,
                      note: p.note,
                      onTap: () => _openDetails(context, p),
                    ),
                  ],
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'View ${featured.shortName} details',
                    onPressed: () => _openDetails(context, featured),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Find a testing facility',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
