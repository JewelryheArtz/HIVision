import 'package:flutter/material.dart';

import 'common.dart';
import 'tkordering.dart';

// SCREEN 2: Source details (content comes from the chosen KitSource)
class SourceDetailsScreen extends StatelessWidget {
  final KitSource source;
  const SourceDetailsScreen({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          GradientHeader(
            title: 'Source details',
            subtitle: 'Step 2 of 3 · Check before you go',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(source.name),
                  const SizedBox(height: 18),
                  InfoCard(
                    color: AppColors.pinkCard,
                    title: source.checkTitle,
                    body: source.checkBody,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    color: AppColors.grayCard,
                    title: 'Kit details',
                    body: source.infoBody,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    color: AppColors.grayCard,
                    title: 'What happens next',
                    body: source.expectBody,
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: source.actionLabel,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderingRedirectScreen(source: source),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Back to sources',
                    onPressed: () => Navigator.pop(context),
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