import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../bottom_nav.dart';
import 'medication_store.dart';

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
    this.medicationName = 'Daily medication',
    this.amount = '1 tablet',
    this.scheduledTime = '8:00 PM',
  });

  @override
  State<LogIntakeScreen> createState() => _LogIntakeScreenState();
}

class _LogIntakeScreenState extends State<LogIntakeScreen> {
  // Read-only fields (medication + scheduled dose)
  late final TextEditingController _medicationController =
      TextEditingController(text: widget.medicationName);
  late final TextEditingController _scheduledController =
      TextEditingController(text: 'Today • ${widget.scheduledTime}');

  // Editable fields
  final _timeController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    _timeController.text = 'Today • $hour:$minute $period';
  }

  @override
  void dispose() {
    _medicationController.dispose();
    _scheduledController.dispose();
    _timeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    // This screen only ever records a dose as TAKEN now.
    final result = IntakeLog(
      status: 'taken',
      takenAt: _timeController.text.trim().isEmpty ? 'Just now' : _timeController.text.trim(),
      note: _noteController.text.trim(),
    );
    Navigator.pop(context, result);
  }

  // Shared decoration for the read-only (disabled) boxes
  InputDecoration _readOnlyDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LogColors.border),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LogColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LogColors.primary, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ---------- Header ----------
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [LogColors.redDark, LogColors.redMid, LogColors.redLight],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
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
                          children: [
                            Icon(Icons.arrow_back, color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text('Back', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Log medication intake',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Record a dose you have taken',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
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
                  const Text(
                    'RECORD AN INTAKE',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w500,
                      color: LogColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Confirm the dose you took.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: LogColors.textDark),
                  ),
                  const SizedBox(height: 20),

                  // Medication (read-only)
                  const Text(
                    'Medication',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LogColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _medicationController,
                    enabled: false,
                    style: const TextStyle(fontSize: 13, color: LogColors.textMuted),
                    decoration: _readOnlyDecoration(),
                  ),
                  const SizedBox(height: 16),

                  // Scheduled dose (read-only)
                  const Text(
                    'Scheduled dose',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LogColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _scheduledController,
                    enabled: false,
                    style: const TextStyle(fontSize: 13, color: LogColors.textMuted),
                    decoration: _readOnlyDecoration(),
                  ),
                  const SizedBox(height: 16),

                  // Time taken (editable)
                  const Text(
                    'Time taken',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LogColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _timeController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Today • 8:05 PM',
                      hintStyle: const TextStyle(fontSize: 13, color: LogColors.textMuted),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: LogColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: LogColors.primary, width: 1.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Note (editable)
                  const Text(
                    'Note (optional)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LogColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Add a note about this intake',
                      hintStyle: const TextStyle(fontSize: 13, color: LogColors.textMuted),
                      contentPadding: const EdgeInsets.all(14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: LogColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: LogColors.primary, width: 1.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Save intake record
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LogColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Save intake record'),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Cancel
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: LogColors.primary,
                        side: const BorderSide(color: LogColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Only record an intake after you have taken it. '
                      'Do not change your dose based on the tracker.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, height: 1.4, color: LogColors.textMuted),
                    ),
                  ),
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