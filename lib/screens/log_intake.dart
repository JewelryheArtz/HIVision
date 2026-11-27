import 'package:flutter/material.dart';
import 'medication_store.dart';
import '../widgets/bottom_nav.dart';
import '../main.dart';

class LogColors {
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

class LogIntakeScreen extends StatefulWidget {
  final String medicationName;
  final String amount;
  final String scheduledTime;

  const LogIntakeScreen({
    super.key,
    required this.medicationName,
    required this.amount,
    required this.scheduledTime,
  });

  @override
  State<LogIntakeScreen> createState() => _LogIntakeScreenState();
}

class _LogIntakeScreenState extends State<LogIntakeScreen> {
  String _selectedStatus = 'taken';
  final TextEditingController _noteController = TextEditingController();
  late final DateTime _timeTaken;

  @override
  void initState() {
    super.initState();
    _timeTaken = DateTime.now();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _formatClock(DateTime d) {
    final h = d.hour % 12;
    final period = d.hour < 12 ? 'AM' : 'PM';
    final minute = d.minute.toString().padLeft(2, '0');
    return 'Today • ${h == 0 ? 12 : h}:$minute $period';
  }

  void _save() {
    Navigator.pop(
      context,
      IntakeLog(
        status: _selectedStatus,
        takenAt: _formatClock(_timeTaken),
        note: _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [LogColors.redDark, LogColors.redMid, LogColors.redLight]),
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
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back, color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text('Back', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Log Intake', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Record your scheduled dose', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                  const Text('RECORD AN INTAKE', style: TextStyle(fontSize: 11, letterSpacing: 0.6, fontWeight: FontWeight.w500, color: LogColors.textMuted)),
                  const SizedBox(height: 10),
                  const Text('Confirm your dose', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: LogColors.textDark)),
                  const SizedBox(height: 16),

                  // Medication summary card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: LogColors.pinkCard, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.medicationName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: LogColors.textDark)),
                        const SizedBox(height: 4),
                        Text('${widget.amount} • Today at ${widget.scheduledTime}', style: const TextStyle(fontSize: 12, color: LogColors.textDark)),
                        const SizedBox(height: 2),
                        const Text('Scheduled dose', style: TextStyle(fontSize: 11, color: LogColors.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('How would you like to log this dose?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LogColors.textDark)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatusButton(label: 'Taken', selected: _selectedStatus == 'taken', onTap: () => setState(() => _selectedStatus = 'taken')),
                      const SizedBox(width: 10),
                      _StatusButton(label: 'Skipped', selected: _selectedStatus == 'skipped', onTap: () => setState(() => _selectedStatus = 'skipped')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text('Time taken', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LogColors.textDark)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(border: Border.all(color: LogColors.border), borderRadius: BorderRadius.circular(10), color: Colors.white),
                    child: Text(_formatClock(_timeTaken), style: const TextStyle(fontSize: 13, color: LogColors.textDark)),
                  ),
                  const SizedBox(height: 16),

                  const Text('Note (optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LogColors.textDark)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Add a note about this intake',
                      hintStyle: const TextStyle(fontSize: 13, color: LogColors.textMuted),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LogColors.border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LogColors.primary, width: 1.4)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(backgroundColor: LogColors.primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      child: const Text('Log intake'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(foregroundColor: LogColors.primary, side: const BorderSide(color: LogColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Only mark a dose as taken after you have taken it. Follow your care provider\'s instructions.', style: TextStyle(fontSize: 11, height: 1.45, color: LogColors.textMuted)),
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

class _StatusButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _StatusButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? LogColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? LogColors.primary : LogColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : LogColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}