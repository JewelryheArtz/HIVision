import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'set_schedule.dart';
import 'medication_store.dart';
import '../widgets/bottom_nav.dart';
import '../main.dart';

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
  // NEW: Optional medication and index for editing
  final Medication? editMedication;
  final int? editIndex;

  const AddMedicationScreen({
    super.key,
    this.editMedication,
    this.editIndex,
  });

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _strengthController;
  late final TextEditingController _doseController;
  late final TextEditingController _instructionsController;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if editing
    _nameController = TextEditingController(
      text: widget.editMedication?.name ?? '',
    );
    _strengthController = TextEditingController(
      text: widget.editMedication?.strength ?? '',
    );
    _doseController = TextEditingController(
      text: widget.editMedication?.amount ?? '',
    );
    _instructionsController = TextEditingController(
      text: widget.editMedication?.instructions ?? '',
    );
  }

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
        builder: (context) => PhoneFrame(
          child: SetScheduleScreen(
            medicationName: _nameController.text.trim(),
            medicationStrength: _strengthController.text.trim(),
            medicationDose: _doseController.text.trim(),
            medicationInstructions: _instructionsController.text.trim(),
            // Pass edit info to SetSchedule
            editMedication: widget.editMedication,
            editIndex: widget.editIndex,
          ),
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
    final isEditing = widget.editMedication != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                    Text(
                      isEditing ? 'Edit medication' : 'Add medication',
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEditing ? 'Update the medication details' : 'Use the details from your care provider',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
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
                  Text(
                    isEditing ? 'Update the details' : 'What would you like to add?',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: FormColors.textDark),
                  ),
                  const SizedBox(height: 20),

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
                      child: Text(isEditing ? 'Continue to update schedule' : 'Continue to schedule'),
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
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }
}