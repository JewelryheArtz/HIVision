import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/bottom_nav.dart';
import '../main.dart';
import 'medication_store.dart';
import 'medication_tracker.dart';

class HistoryColors {
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

enum RecordStatus { taken, skipped, missed }

class MedicationHistoryScreen extends StatefulWidget {
  const MedicationHistoryScreen({super.key});

  @override
  State<MedicationHistoryScreen> createState() => _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  String _range = '7 days';

  @override
  void initState() {
    super.initState();
    MedicationStore.instance.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    MedicationStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  List<HistoryEntry> _getFilteredHistory() {
    final now = DateTime.now();
    final history = MedicationStore.instance.history;
    if (_range == '7 days') return history.where((e) => now.difference(e.date).inDays < 7).toList();
    if (_range == '30 days') return history.where((e) => now.difference(e.date).inDays < 30).toList();
    return history;
  }

  Map<String, List<HistoryEntry>> _getGroupedHistory() {
    final filtered = _getFilteredHistory();
    final grouped = <String, List<HistoryEntry>>{};
    
    for (final entry in filtered) {
      grouped.putIfAbsent(entry.medicationName, () => []).add(entry);
    }
    
    return grouped;
  }

  int get _scheduled {
    final grouped = _getGroupedHistory();
    return grouped.length;
  }

  int get _taken {
    final grouped = _getGroupedHistory();
    int count = 0;
    for (final entries in grouped.values) {
      if (entries.isNotEmpty && entries.last.status == 'taken') {
        count++;
      }
    }
    return count;
  }

  int get _adherencePercent => _scheduled == 0 ? 0 : ((_taken / _scheduled) * 100).round();

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(entryDay).inDays;
    const dayNames = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
    const monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    if (diff == 0) return 'TODAY · ${dayNames[date.weekday - 1].substring(0, 3)}, ${date.day} ${monthNames[date.month - 1]}';
    if (diff == 1) return 'YESTERDAY · ${dayNames[date.weekday - 1].substring(0, 3)}, ${date.day} ${monthNames[date.month - 1]}';
    return '${dayNames[date.weekday - 1]} · ${date.day} ${monthNames[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _getGroupedHistory();
    
    DateTime? mostRecentDate;
    for (final entries in grouped.values) {
      if (entries.isNotEmpty) {
        final latest = entries.last;
        if (mostRecentDate == null || latest.date.isAfter(mostRecentDate)) {
          mostRecentDate = latest.date;
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [HistoryColors.redDark, HistoryColors.redMid, HistoryColors.redLight]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.arrow_back, color: Colors.white, size: 22), SizedBox(width: 8), Text('Back', style: TextStyle(color: Colors.white, fontSize: 12))],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Medication History', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Your saved intake records', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YOUR RECORDS', style: TextStyle(fontSize: 11, letterSpacing: 0.6, fontWeight: FontWeight.w500, color: HistoryColors.textMuted)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _RangeChip(label: '7 days', selected: _range == '7 days', onTap: () => setState(() => _range = '7 days')),
                      const SizedBox(width: 8),
                      _RangeChip(label: '30 days', selected: _range == '30 days', onTap: () => setState(() => _range = '30 days')),
                      const SizedBox(width: 8),
                      _RangeChip(label: 'All', selected: _range == 'All', onTap: () => setState(() => _range = 'All')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: HistoryColors.pinkCard, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_adherencePercent% adherence', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: HistoryColors.textDark)),
                        const SizedBox(height: 6),
                        Text('$_taken of $_scheduled scheduled doses taken', style: const TextStyle(fontSize: 12, color: HistoryColors.textMuted)),
                        const SizedBox(height: 2),
                        const Text('Based on your most recent log for each medication', style: TextStyle(fontSize: 12, color: HistoryColors.textMuted)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: _scheduled == 0 ? 0 : _taken / _scheduled, minHeight: 6, backgroundColor: Colors.white, valueColor: const AlwaysStoppedAnimation<Color>(HistoryColors.primary)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (mostRecentDate != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _formatDateHeader(mostRecentDate),
                        style: const TextStyle(fontSize: 11, letterSpacing: 0.6, fontWeight: FontWeight.w700, color: HistoryColors.primary),
                      ),
                    ),
                  if (grouped.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(child: Text('No intake records yet.\nLog a medication to see it here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: HistoryColors.textMuted))),
                    )
                  else
                    for (final entry in grouped.entries) ...[
                      _MedicationGroup(medicationName: entry.key, logs: entry.value),
                      const SizedBox(height: 16),
                    ],
                  const SizedBox(height: 8),
                  Text('All dose logs shown grouped by medication. Adherence is based on the most recent log for each medication.', style: const TextStyle(fontSize: 11, height: 1.45, color: HistoryColors.textMuted)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const PhoneFrame(child: MedicationTrackerScreen())),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: HistoryColors.primary, side: const BorderSide(color: HistoryColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      child: const Text('Back to medication tracker'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }
}

class _MedicationGroup extends StatelessWidget {
  final String medicationName;
  final List<HistoryEntry> logs;

  const _MedicationGroup({required this.medicationName, required this.logs});

  @override
  Widget build(BuildContext context) {
    final latestLog = logs.last;
    final latestStatus = latestLog.status == 'taken' ? RecordStatus.taken : latestLog.status == 'skipped' ? RecordStatus.skipped : RecordStatus.missed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: HistoryColors.grayCard, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(medicationName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: HistoryColors.textDark)),
              _StatusBadge(status: latestStatus),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: HistoryColors.border),
          const SizedBox(height: 12),
          for (int i = 0; i < logs.length; i++) ...[
            _LogEntry(log: logs[i], isLast: i == logs.length - 1),
            if (i < logs.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _LogEntry extends StatelessWidget {
  final HistoryEntry log;
  final bool isLast;

  const _LogEntry({required this.log, required this.isLast});

  String _getLogMethod() {
    if (log.note.contains('AI Assistant')) return 'via AI Assistant';
    return 'via Log Intake';
  }

  @override
  Widget build(BuildContext context) {
    String detail;
    if (log.status == 'taken') {
      detail = '${log.scheduledTime} scheduled · Taken at ${log.loggedAt}';
    } else if (log.status == 'skipped') {
      detail = '${log.scheduledTime} scheduled · Skipped';
    } else {
      detail = '${log.scheduledTime} scheduled · Not taken';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(detail, style: const TextStyle(fontSize: 12, color: HistoryColors.textDark)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              log.note.contains('AI Assistant') ? Icons.smart_toy : Icons.touch_app,
              size: 12,
              color: HistoryColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text('Logged ${_getLogMethod()}', style: const TextStyle(fontSize: 11, color: HistoryColors.textMuted)),
          ],
        ),
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RangeChip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(color: selected ? HistoryColors.primary : Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: selected ? HistoryColors.primary : HistoryColors.border)),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? Colors.white : HistoryColors.textDark)),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RecordStatus status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    if (status == RecordStatus.missed) {
      return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: HistoryColors.primary, borderRadius: BorderRadius.circular(8)), child: const Text('Missed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)));
    }
    final isTaken = status == RecordStatus.taken;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: isTaken ? HistoryColors.primary : HistoryColors.border)),
      child: Text(isTaken ? 'Taken' : 'Skipped', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isTaken ? HistoryColors.primary : HistoryColors.textMuted)),
    );
  }
}