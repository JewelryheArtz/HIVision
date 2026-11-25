import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'set_schedule.dart';
import '../bottom_nav.dart';

class FormColors {
  static const redDark = Color(0xFF7A0000);
  static const redMid = Color(0xFFB00000);
  static const redLight = Color(0xFFD10A0A);
  static const primary = Color(0xFFB30000);
  static const pinkCard = Color(0xFFFFF0EE);
  static const grayCard = Color(0xFFF4F3F3);
  static const textDark = Color(0xFF111111);
  static const textMuted = Color(0xFF6B6B6B);
  static const error = Color(0xFFB3261E);
  static const border = Color(0xFFDDDDDD);
}

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController();
  final _doseController = TextEditingController();
  final _instructionsController = TextEditingController();
  bool _showErrors = false;

  @override
  void dispose() {
    _nameController.dispose();
    _strengthController.dispose();
    _doseController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  bool get _nameError => _showErrors && _nameController.text.trim().isEmpty;
  bool get _strengthError => _showErrors && _strengthController.text.trim().isEmpty;
  bool get _doseError => _showErrors && _doseController.text.trim().isEmpty;
  bool get _hasErrors => _nameError || _strengthError || _doseError;

  void _continueToSchedule() {
    if (_nameController.text.trim().isEmpty ||
        _strengthController.text.trim().isEmpty ||
        _doseController.text.trim().isEmpty) {
      setState(() => _showErrors = true);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetScheduleScreen(
          medicationName: _nameController.text.trim(),
          medicationStrength: _strengthController.text.trim(),
          medicationDose: _doseController.text.trim(),
          medicationInstructions: _instructionsController.text.trim(),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint, {bool error = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: FormColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: error ? FormColors.error : FormColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: FormColors.primary, width: 1.4),
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
                colors: [FormColors.redDark, FormColors.redMid, FormColors.redLight],
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
                      'Add medication',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use the details from your care provider',
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
                    'MEDICATION DETAILS',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w500,
                      color: FormColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'What would you like to add?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: FormColors.textDark),
                  ),
                  const SizedBox(height: 20),

                  // Medication name
                  const Text(
                    'Medication name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: FormColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 13),
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration('Enter the name on your prescription', error: _nameError),
                  ),
                  if (_nameError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('Enter the medication name.', style: TextStyle(fontSize: 11, color: FormColors.error)),
                    ),
                  const SizedBox(height: 16),

                  // Strength
                  const Text(
                    'Strength',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: FormColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _strengthController,
                    style: const TextStyle(fontSize: 13),
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration('e.g., 500 mg', error: _strengthError),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'How much medicine is in one unit (e.g., 500 mg, 250 mcg)',
                      style: TextStyle(fontSize: 11, color: FormColors.textMuted),
                    ),
                  ),
                  if (_strengthError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('Enter the strength.', style: TextStyle(fontSize: 11, color: FormColors.error)),
                    ),
                  const SizedBox(height: 16),

                  // Dose
                  const Text(
                    'Dose',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: FormColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _doseController,
                    style: const TextStyle(fontSize: 13),
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration('e.g., 2 tablets', error: _doseError),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'How many units you take each time (e.g., 2 tablets, 1 capsule)',
                      style: TextStyle(fontSize: 11, color: FormColors.textMuted),
                    ),
                  ),
                  if (_doseError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('Enter the dose amount.', style: TextStyle(fontSize: 11, color: FormColors.error)),
                    ),
                  const SizedBox(height: 16),

                  // Instructions (optional)
                  const Text(
                    'Instructions (optional)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: FormColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _instructionsController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13),
                    decoration: _fieldDecoration('e.g., Take with food, or as directed by your doctor'),
                  ),
                  const SizedBox(height: 24),

                  // Continue to schedule
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _continueToSchedule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FormColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Continue to schedule'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Copy the details from your prescription. This app does not recommend medications or doses.',
                      style: TextStyle(fontSize: 11, height: 1.4, color: FormColors.textMuted),
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