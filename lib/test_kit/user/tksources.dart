import 'package:flutter/material.dart';

import 'common.dart';
import 'tkdetails.dart';

// SCREEN 1: Get a Test Kit
class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  void _openDetails(BuildContext context, KitSource source) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SourceDetailsScreen(source: source)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          GradientHeader(
            title: 'Get a Test Kit',
            subtitle: 'Choose where to get your kit',
            backLabel: 'Home',
            onBack: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('STEP 1 OF 3'),
                  const SizedBox(height: 14),
                  const SectionTitle('Choose a source.'),
                  const SizedBox(height: 18),
                  for (var i = 0; i < kSources.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    SourceCard(
                      color: i == 0 ? AppColors.pinkCard : AppColors.grayCard,
                      title: kSources[i].name,
                      subtitle: kSources[i].cardSubtitle,
                      onTap: () => _openDetails(context, kSources[i]),
                    ),
                  ],
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'See source details',
                    onPressed: () => _openDetails(context, kSources.first),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Find a testing facility instead',
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(height: 14),
                  const FootNote(
                    'Use an authorized kit and follow its instructions. Each provider sets its own prices and availability.',
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