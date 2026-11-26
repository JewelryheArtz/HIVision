import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'medication_store.dart';
import '../bottom_nav.dart';
import 'log_intake.dart';
import 'medication_history.dart';
import 'add_medication.dart';

class TrackerColors {
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

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen({super.key});

  @override
  State<MedicationTrackerScreen> createState() => _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  final store = MedicationStore.instance;

  @override
  void initState() {
    super.initState();
    store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  int get _takenCount => store.todayLogs.values.where((v) => v.status == 'taken').length;

  Medication? get _nextMed {
    for (final m in store.items) {
      if (!store.todayLogs.containsKey(m.name)) return m;
    }
    return null;
  }

  Future<void> _logIntake(Medication med) async {
    final result = await Navigator.push<IntakeLog>(
      context,
      MaterialPageRoute(
        builder: (context) => LogIntakeScreen(
          medicationName: med.name,
          amount: med.amount,
          scheduledTime: med.times.isNotEmpty ? med.times.first : 'Unknown',
        ),
      ),
    );
    if (result != null) {
      store.logIntake(med.name, result, med.times.isNotEmpty ? med.times.first : 'Unknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    final meds = store.items;
    final total = meds.length;
    final taken = _takenCount;
    final next = _nextMed;

    return Scaffold(
      body: Column(
        children: [
          // ---------- Header ----------
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [TrackerColors.redDark, TrackerColors.redMid, TrackerColors.redLight]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Medication Tracker', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Doses and reminders', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),

          // ---------- Body ----------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========== EMPTY STATE ==========
                  if (meds.isEmpty) ...[
                    const Text(
                      'YOUR MEDICATIONS',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w500,
                        color: TrackerColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: TrackerColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(LucideIcons.pill, color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No medications yet',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: TrackerColors.textDark),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Add your first medication to keep your doses and reminders in one place.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, height: 1.45, color: TrackerColors.textMuted),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicationScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TrackerColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              child: const Text('Add medication'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Follow the medication instructions from your care provider.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: TrackerColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ========== POPULATED STATE ==========
                  if (meds.isNotEmpty) ...[
                    const Text(
                      'YOUR MEDICATIONS',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w500,
                        color: TrackerColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your daily routine',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TrackerColors.textDark),
                    ),
                    const SizedBox(height: 14),

                    // Progress card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: TrackerColors.pinkCard, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Today's progress", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TrackerColors.textDark)),
                          const SizedBox(height: 4),
                          Text('$taken of $total doses taken', style: const TextStyle(fontSize: 12, color: TrackerColors.textMuted)),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total == 0 ? 0 : taken / total,
                              minHeight: 6,
                              backgroundColor: Colors.white,
                              valueColor: const AlwaysStoppedAnimation<Color>(TrackerColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Medication cards
                    for (final med in meds) ...[
                      _DoseCard(
                        med: med,
                        log: store.todayLogs[med.name],
                        isNext: next != null && next.name == med.name,
                        onLogIntake: () => _logIntake(med),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 4),

                    // Add medication button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicationScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TrackerColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Add medication'),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // View medication history
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicationHistoryScreen()));
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('View medication history', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TrackerColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const SizedBox(
                      width: double.infinity,
                      child: Text('Follow the medication instructions from your care provider.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: TrackerColors.textMuted)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}

// ---------- Medication card ----------
class _DoseCard extends StatelessWidget {
  final Medication med;
  final IntakeLog? log;
  final bool isNext;
  final VoidCallback onLogIntake;

  const _DoseCard({required this.med, required this.log, required this.isNext, required this.onLogIntake});

  @override
  Widget build(BuildContext context) {
    final highlight = isNext && log == null;
    final timesString = med.times.isNotEmpty ? med.times.join(", ") : 'No time set';

    String detailLine;
    if (log != null) {
      if (log!.status == 'taken') {
        final notePart = log!.note.isNotEmpty ? ' • ${log!.note}' : '';
        detailLine = '${log!.takenAt}$notePart';
      } else if (log!.status == 'skipped') {
        detailLine = 'Skipped${log!.note.isNotEmpty ? ' • ${log!.note}' : ''}';
      } else {
        detailLine = 'Snoozed${log!.note.isNotEmpty ? ' • ${log!.note}' : ''}';
      }
    } else {
      final reminderText = med.remindersOn ? 'Reminder on' : 'Reminder off';
      detailLine = '${med.repeatLabel} • $reminderText';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? TrackerColors.pinkCard : TrackerColors.grayCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: TrackerColors.textDark)),
                    const SizedBox(height: 4),
                    Text('${med.amount} • $timesString', style: const TextStyle(fontSize: 12, color: TrackerColors.textMuted)),
                    const SizedBox(height: 2),
                    Text(detailLine, style: const TextStyle(fontSize: 12, color: TrackerColors.textMuted)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _Badge(label: _badgeLabel(), filled: highlight),
            ],
          ),
          if (highlight) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onLogIntake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TrackerColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                child: const Text('Log intake'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _badgeLabel() {
    if (log == null) return isNext ? 'Next' : 'Later';
    if (log!.status == 'taken') return 'Taken';
    if (log!.status == 'skipped') return 'Skipped';
    return 'Later';
  }
}

// ---------- Badge ----------
class _Badge extends StatelessWidget {
  final String label;
  final bool filled;
  const _Badge({required this.label, required this.filled});

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(color: TrackerColors.primary, borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
      );
    }
    final isTaken = label == 'Taken';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isTaken ? TrackerColors.primary : TrackerColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isTaken ? TrackerColors.primary : TrackerColors.textMuted),
      ),
    );
  }
}