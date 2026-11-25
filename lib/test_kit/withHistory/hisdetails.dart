import 'package:flutter/material.dart';

import 'common.dart';
import 'hisordering.dart';

// SCREEN 2: Source details (content comes from the chosen KitProvider)
class SourceDetailsScreen extends StatelessWidget {
  final KitProvider provider;
  const SourceDetailsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          GradientHeader(
            title: 'Source details',
            subtitle: 'Check availability with the provider',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(provider.name),
                  const SizedBox(height: 6),
                  SubText(provider.type),
                  const SizedBox(height: 16),
                  ProductCard(
                    title: provider.kitName,
                    subtitle: provider.kitInfo,
                    price: provider.productPrice,
                    status: provider.status,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    color: AppColors.grayCard,
                    title: provider.infoTitle,
                    body: provider.infoBody,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    color: AppColors.grayCard,
                    title: provider.checkTitle,
                    body: provider.checkBody,
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: provider.actionLabel,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OrderingRedirectScreen(provider: provider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Back to kit sources',
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
