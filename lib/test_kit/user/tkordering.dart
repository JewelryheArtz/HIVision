import 'package:flutter/material.dart';

import 'common.dart';

// SCREEN 3: Redirection (content comes from the chosen KitSource)
class OrderingRedirectScreen extends StatelessWidget {
  final KitSource source;
  const OrderingRedirectScreen({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          GradientHeader(
            title: 'Continue to provider',
            subtitle: 'Step 3 of 3 · You’re leaving the app',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('STEP 3 OF 3'),
                  const SizedBox(height: 14),
                  const SectionTitle('Open the provider’s website.'),
                  const SizedBox(height: 18),
                  InfoCard(
                    color: AppColors.pinkCard,
                    title: source.redirectTitle,
                    body: source.redirectBody,
                  ),
                  const SizedBox(height: 12),
                  const InfoCard(
                    color: AppColors.grayCard,
                    title: 'Your records stay here',
                    body:
                        'Your medication records and test results are not shared with the provider.',
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Before you enter personal or payment details, check the website address and the provider’s credentials.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Open provider website',
                    onPressed: () {
                      // TODO: open the verified provider URL with url_launcher:
                      // launchUrl(Uri.parse('https://provider-website.com'),
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