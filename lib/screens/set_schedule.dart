import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'medication_store.dart';
import '../bottom_nav.dart';

class AppColors {
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

class SetScheduleScreen extends StatefulWidget {
  final String medicationName;
  final String medicationStrength;
  final String medicationDose;
  final String medicationInstructions;

  const SetScheduleScreen({
    super.key,
    required this.medicationName,
    required this.medicationStrength,
    required this.medicationDose,
    required this.medicationInstructions,
  });

  @override
  State<SetScheduleScreen> createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  String _selectedFrequency = 'Specific days';
  bool _remindersOn = true;

  String _hoursInterval = '4';
  final List<String> _hourOptions = ['2', '4', '6', '8', '12'];

  final List<bool> _selectedDays = [true, false, true, false, true, false, false];
  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Time is now picked HERE (no longer passed from Add screen)
  late final List<TextEditingController> _timeControllers = [
    TextEditingController(text: ''),
  ];

  DateTime _startDate = DateTime(2026, 11, 11);

  @override
  void dispose() {
    for (var controller in _timeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleDay(int index) {
    setState(() => _selectedDays[index] = !_selectedDays[index]);
  }

  void _addTimeField() {
    setState(() => _timeControllers.add(TextEditingController()));
  }

  String _formatDate(DateTime d) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            timePickerTheme: const TimePickerThemeData(
              dayPeriodColor: AppColors.primary,
              dayPeriodTextColor: Colors.white,
              hourMinuteColor: Colors.white,
              hourMinuteTextColor: AppColors.textDark,
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _timeControllers[index].text = picked.format(context));
    }
  }

  String _buildRepeatLabel() {
    if (_selectedFrequency == 'Every day') return 'Every day';
    if (_selectedFrequency == 'Every few hours') return 'Every $_hoursInterval hours';
    final selected = <String>[];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) selected.add(_dayNames[i]);
    }
    return selected.isEmpty ? 'Every day' : selected.join(', ');
  }

  void _saveSchedule() {
    final allTimes = _timeControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final medication = Medication(
      name: widget.medicationName,
      amount: widget.medicationDose,
      strength: widget.medicationStrength,
      instructions: widget.medicationInstructions,
      times: allTimes,
      repeatLabel: _buildRepeatLabel(),
      remindersOn: _remindersOn,
    );

    MedicationStore.instance.add(medication);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.redDark, AppColors.redMid, AppColors.redLight]),
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
                    const Text('Set Schedule', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Choose when to receive reminders', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ADDING: ${widget.medicationName}', style: const TextStyle(fontSize: 11, letterSpacing: 0.6, fontWeight: FontWeight.w500, color: AppColors.textMuted)),
                  const SizedBox(height: 16),

                  // Frequency
                  const Text('Frequency', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _FrequencyButton(label: 'Every day', isSelected: _selectedFrequency == 'Every day', onTap: () => setState(() => _selectedFrequency = 'Every day')),
                      const SizedBox(width: 8),
                      _FrequencyButton(label: 'Specific days', isSelected: _selectedFrequency == 'Specific days', onTap: () => setState(() => _selectedFrequency = 'Specific days')),
                      const SizedBox(width: 8),
                      _FrequencyButton(label: 'Every few hours', isSelected: _selectedFrequency == 'Every few hours', onTap: () => setState(() => _selectedFrequency = 'Every few hours')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Hours interval
                  if (_selectedFrequency == 'Every few hours') ...[
                    const Text('Repeat every', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _hoursInterval,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: _hourOptions.map((String value) => DropdownMenuItem<String>(value: value, child: Text('$value hours', style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (newValue) => setState(() => _hoursInterval = newValue!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Repeat on days
                  if (_selectedFrequency == 'Specific days') ...[
                    const Text('Repeat on', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final isSelected = _selectedDays[index];
                        return GestureDetector(
                          onTap: () => _toggleDay(index),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _dayLabels[index],
                              style: TextStyle(color: isSelected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Dose time
                  const Text('Dose time', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  ...List.generate(_timeControllers.length, (index) {
                    final hasValue = _timeControllers[index].text.isNotEmpty;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _pickTime(index),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  hasValue ? _timeControllers[index].text : 'Select time',
                                  style: TextStyle(fontSize: 13, color: hasValue ? AppColors.textDark : AppColors.textMuted),
                                ),
                              ),
                              const Icon(Icons.access_time, color: AppColors.textMuted, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _addTimeField,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('+ Add another time', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Start date
                  const Text('Start date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(child: Text(_formatDate(_startDate), style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
                          const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reminders toggle
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.pinkCard, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_remindersOn ? 'Reminders on' : 'Reminders off', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                              const SizedBox(height: 4),
                              Text(_remindersOn ? 'Receive a reminder at the scheduled time.' : 'You will not receive reminders.', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _remindersOn,
                          onChanged: (bool value) => setState(() => _remindersOn = value),
                          activeColor: AppColors.primary,
                          activeTrackColor: AppColors.primary.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saveSchedule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Save schedule'),
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

class _FrequencyButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FrequencyButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}