import 'package:flutter/material.dart';

import 'common.dart';

// SCREEN 3: Ordering redirection (content comes from the chosen KitProvider)
class OrderingRedirectScreen extends StatelessWidget {
  final KitProvider provider;
  const OrderingRedirectScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          GradientHeader(
            title: 'Ordering redirection',
            subtitle: 'Continue on a provider website',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle('Continue with ${provider.shortName}?'),
                  const SizedBox(height: 6),
                  const SubText('You\'re about to leave this app.'),
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
                        Text(
                          provider.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.website,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Provider website · Example destination',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectionCard(
                    label: 'Your selection',
                    title: '${provider.kitName} × 1',
                    price: provider.productPrice,
                    note: provider.selectionNote,
                  ),
                  const SizedBox(height: 12),
                  const InfoCard(
                    color: AppColors.grayCard,
                    title: 'Your health records stay here',
                    body:
                        'Medication records and test results are not sent.\nThe provider handles payment and delivery.\nContinuing does not place an order.',
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Continue to provider website',
                    onPressed: () {
                      // TODO: open the provider URL with url_launcher:
                      // launchUrl(Uri.parse('https://${provider.website}'),
                      //     mode: LaunchMode.externalApplication);
                    },
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Stay in the app',
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
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
