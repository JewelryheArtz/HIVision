import 'package:material_ui/material_ui.dart';

import '../main.dart';
import '../instruction/scan_instructions.dart';
import '../instruction/scan_navigation.dart';
import '../widgets/app_components.dart';
import 'scan_history.dart';
import 'scan_saved_record.dart';

// !!!!!!!!!!!!!!!!!!!!!!!!!!!  TODO (DATABASE PARTNER)  !!!!!!!!!!!!!!!!!!!!!!!!
// DUMMY DATA: replace with real data once the database is connected.
class _DemoData {
  static const userName = 'Alex';
  static const savedFacility = 'Your saved facility · Community health centre';
  static const medicationReminder = 'Daily reminder set · 8:00 PM';
  static const assistantConversation =
      'Continue your conversation about reminders';
}

class HomeWithActivityScreen extends StatefulWidget {
  const HomeWithActivityScreen({super.key});

  @override
  State<HomeWithActivityScreen> createState() => _HomeWithActivityScreenState();
}

class _HomeWithActivityScreenState extends State<HomeWithActivityScreen> {
  int _navIndex = 0;

  Future<void> _openNewTest() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ScanInstructionsScreen()),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openSavedHistory() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ScanHistoryScreen()));
    if (mounted) setState(() {});
  }

  // NOTE: stand-in. Opens the old HomeScreen until a Test kits page exists.
  void _openTestKits() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const HomeScreen()));
  }

  void _onNavTap(int index) {
    if (index == 0) {
      goToHome(context);
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final latest = SavedScanRecord.latestRecord;

    final records = SavedScanRecord.demoRecords;
    final previous = records.length > 1 ? records[1] : null;

    return Scaffold(
      body: Column(
        children: [
          const AppGradientHeader(
            overline: 'HOME · DEMO',
            title: 'Welcome back, ${_DemoData.userName}',
            subtitle: 'Your testing, care and daily support',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR DAILY SUPPORT',
                    style: AppTextStyles.overline,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Pick up where you left off',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _ActivityLatestScanCard(
                    record: latest,
                    onViewHistory: _openSavedHistory,
                  ),

                  const SizedBox(height: 12),
                  _ActivityPrimaryButton(
                    label: 'Scan a new test',
                    onTap: _openNewTest,
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Recent activity',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (previous != null)
                    _ActivityInfoTile(
                      title: previous.resultLabel,
                      subtitle:
                          '${previous.timestampLabel()}\n'
                          '${previous.summary}',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => previous.toHistoryRecordScreen(),
                        ),
                      ),
                    )
                  else
                    const _ActivityInfoTile(
                      title: 'No recent activity',
                      subtitle:
                          'Your previous completed scans will appear here.',
                    ),

                  const SizedBox(height: 18),
                  const Text('YOUR CARE TOOLS', style: AppTextStyles.overline),
                  const SizedBox(height: 14),

                  _ActivityInfoTile(
                    title: 'Facilities near me',
                    subtitle: _DemoData.savedFacility,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FacilitiesScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _ActivityInfoTile(
                    title: 'Test kits',
                    subtitle: 'Browse kit sources or reorder a test kit',
                    onTap: _openTestKits,
                  ),
                  const SizedBox(height: 12),

                  const _ActivityInfoTile(
                    title: 'Medication tracker',
                    subtitle: _DemoData.medicationReminder,
                  ),
                  const SizedBox(height: 12),

                  const _ActivityInfoTile(
                    title: 'Medication assistant',
                    subtitle: _DemoData.assistantConversation,
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Demo information only. Image-based guidance is not a diagnosis.',
                    style: AppTextStyles.caption,
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

class _ActivityLatestScanCard extends StatelessWidget {
  final SavedScanRecord? record;
  final VoidCallback onViewHistory;

  const _ActivityLatestScanCard({
    required this.record,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pinkCard,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('LATEST SCAN', style: AppTextStyles.overline),
                GestureDetector(
                  onTap: onViewHistory,
                  child: const Text(
                    'View history',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (record != null) ...[
              Text(
                record!.resultLabel,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(record!.timestampLabel(), style: AppTextStyles.caption),
              const SizedBox(height: 4),
              Text(record!.summary, style: AppTextStyles.caption),
            ] else ...[
              const Text(
                'No scans yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your completed test scans will appear here.',
                style: AppTextStyles.caption,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActivityPrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

class _ActivityInfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActivityInfoTile({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grayCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              const SizedBox(height: 6),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}
