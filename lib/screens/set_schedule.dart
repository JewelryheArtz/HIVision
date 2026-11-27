import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'medication_store.dart';
import '../widgets/bottom_nav.dart';

class AppColors {
  static const redDark = Color(0xFF7A0000);
  static const redMid = Color(0xFFB00000);
  static const redLight = Color(0xFFD10A0A);
  static const primary = Color(0xFFB30000);
  static const pinkCard = Color(0xFFFFF0EE);
  static const textDark = Color(0xFF111111);
  static const textMuted = Color(0xFF6B6B6B);
  static const border = Color(0xFFDDDDDD);
  static const error = Color(0xFFB3261E);
}

class SetScheduleScreen extends StatefulWidget {
  final String medicationName;
  final String medicationStrength;
  final String medicationDose;
  final String medicationInstructions;
  final Medication? editMedication;
  final int? editIndex;

  const SetScheduleScreen({
    super.key,
    required this.medicationName,
    required this.medicationStrength,
    required this.medicationDose,
    required this.medicationInstructions,
    this.editMedication,
    this.editIndex,
  });

  @override
  State<SetScheduleScreen> createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  String _selectedFrequency = 'Every day';
  bool _remindersOn = true;

  String _hoursInterval = '4';
  final List<String> _hourOptions = ['1', '2', '4', '6', '8', '12'];

  final List<bool> _selectedDays = [false, true, false, true, false, true, false];
  final List<String> _dayLabels = ['S', 'M', 'T', 'W', 'TH', 'F', 'S'];
  final List<String> _dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  final TextEditingController _timeController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  bool get _isEditing => widget.editMedication != null;

  @override
  void initState() {
    super.initState();
    if (widget.editMedication != null) {
      final med = widget.editMedication!;
      _remindersOn = med.remindersOn;
      _startDate = med.startDate;
      _endDate = med.endDate;
      if (med.times.isNotEmpty) {
        _timeController.text = med.times.first;
      }
      _parseRepeatLabel(med.repeatLabel);
    }
  }

  void _parseRepeatLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.startsWith('every day')) {
      _selectedFrequency = 'Every day';
    } else {
      _selectedFrequency = 'Specific days';
      for (int i = 0; i < _selectedDays.length; i++) {
        _selectedDays[i] = lower.contains(_dayNames[i].toLowerCase());
      }
    }
    final match = RegExp(r'every (\d+) hours?').firstMatch(lower);
    if (match != null) {
      _hoursInterval = match.group(1)!;
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  void _toggleDay(int index) => setState(() => _selectedDays[index] = !_selectedDays[index]);

  String _formatDate(DateTime d) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: AppColors.textDark,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: AppColors.textDark,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<TimeOfDay?> _showCustomTimePicker() async {
    final hourController = TextEditingController();
    final minuteController = TextEditingController();
    bool isPm = TimeOfDay.now().period == DayPeriod.pm;
    String? error;

    final result = await showDialog<TimeOfDay>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            title: const Text('Enter time',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 76,
                      child: TextField(
                        controller: hourController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.textDark),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setDialogState(() => error = null),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(':', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ),
                    SizedBox(
                      width: 76,
                      child: TextField(
                        controller: minuteController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.textDark),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setDialogState(() => error = null),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      children: [
                        _AmPmButton(label: 'AM', selected: !isPm, onTap: () => setDialogState(() => isPm = false)),
                        _AmPmButton(label: 'PM', selected: isPm, onTap: () => setDialogState(() => isPm = true)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 76, child: Text('Hour', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
                    SizedBox(width: 18),
                    SizedBox(width: 76, child: Text('Minute', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
                  ],
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.error)),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () {
                  final h = int.tryParse(hourController.text);
                  final m = int.tryParse(minuteController.text);
                  if (h == null || m == null || h < 1 || h > 12 || m > 59) {
                    setDialogState(() => error = 'Enter a valid time (hour 1-12, minute 0-59).');
                    return;
                  }
                  final hour24 = isPm ? (h == 12 ? 12 : h + 12) : (h == 12 ? 0 : h);
                  Navigator.pop(dialogContext, TimeOfDay(hour: hour24, minute: m));
                },
                child: const Text('OK', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );

    hourController.dispose();
    minuteController.dispose();
    return result;
  }

  Future<void> _pickTime() async {
    final picked = await _showCustomTimePicker();
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  String _buildRepeatLabel() {
    String daysPart;
    if (_selectedFrequency == 'Every day') {
      daysPart = 'Every day';
    } else {
      final sel = <String>[];
      for (var i = 0; i < _selectedDays.length; i++) {
        if (_selectedDays[i]) sel.add(_dayNames[i]);
      }
      daysPart = sel.isEmpty ? 'Every day' : sel.join(', ');
    }
    return '$daysPart, every $_hoursInterval hours';
  }

  void _saveSchedule() {
    if (_timeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a dose time.'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // End date is required only when editing an existing medication
    if (_isEditing && _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an end date.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newMed = Medication(
      name: widget.medicationName,
      amount: widget.medicationDose,
      strength: widget.medicationStrength,
      instructions: widget.medicationInstructions,
      times: [_timeController.text.trim()],
      repeatLabel: _buildRepeatLabel(),
      remindersOn: _remindersOn,
      startDate: _startDate,
      endDate: _endDate,
    );

    if (_isEditing && widget.editIndex != null) {
      MedicationStore.instance.edit(widget.editIndex!, newMed);
    } else {
      MedicationStore.instance.add(newMed);
    }
    Navigator.popUntil(context, (route) => route.isFirst);
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
                    Text(
                      _isEditing ? 'Edit schedule' : 'Set Schedule',
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isEditing ? 'Update when to receive reminders' : 'Choose when to receive reminders',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_isEditing ? "EDITING" : "ADDING"}: ${widget.medicationName}',
                      style: const TextStyle(fontSize: 11, letterSpacing: 0.6, fontWeight: FontWeight.w500, color: AppColors.textMuted)),
                  const SizedBox(height: 16),

                  const Text('Frequency', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _FreqChip(label: 'Every day', selected: _selectedFrequency == 'Every day', onTap: () => setState(() => _selectedFrequency = 'Every day')),
                      const SizedBox(width: 8),
                      _FreqChip(label: 'Specific days', selected: _selectedFrequency == 'Specific days', onTap: () => setState(() => _selectedFrequency = 'Specific days')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (_selectedFrequency == 'Specific days') ...[
                    const Text('Repeat on', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (i) {
                        final on = _selectedDays[i];
                        return GestureDetector(
                          onTap: () => _toggleDay(i),
                          child: Container(
                            width: 40, height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: on ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: on ? AppColors.primary : AppColors.border),
                            ),
                            child: Text(_dayLabels[i], style: TextStyle(color: on ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 13)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],

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
                        items: _hourOptions.map((v) => DropdownMenuItem(
                          value: v,
                          child: Text(v == '1' ? '1 hour' : '$v hours', style: const TextStyle(fontSize: 13)),
                        )).toList(),
                        onChanged: (v) => setState(() => _hoursInterval = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('First dose time', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickTime,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(child: Text(_timeController.text.isNotEmpty ? _timeController.text : 'Select time',
                              style: TextStyle(fontSize: 13, color: _timeController.text.isNotEmpty ? AppColors.textDark : AppColors.textMuted))),
                          const Icon(Icons.access_time, color: AppColors.textMuted, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('Start date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickStartDate,
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
                  const SizedBox(height: 16),

                  const Text('End date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickEndDate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              // Optional label when adding, required label when editing
                              _endDate == null
                                  ? (_isEditing ? 'Select end date' : 'Select end date (optional)')
                                  : _formatDate(_endDate!),
                              style: TextStyle(
                                fontSize: 13,
                                color: _endDate == null ? AppColors.textMuted : AppColors.textDark,
                              ),
                            ),
                          ),
                          const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

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
                        Switch(value: _remindersOn, onChanged: (v) => setState(() => _remindersOn = v), activeColor: AppColors.primary, activeTrackColor: AppColors.primary.withOpacity(0.3)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton(
                      onPressed: _saveSchedule,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      child: Text(_isEditing ? 'Save changes' : 'Save schedule'),
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

class _AmPmButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _AmPmButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          border: Border.all(color: AppColors.border),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : AppColors.textDark,
        )),
      ),
    );
  }
}

class _FreqChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FreqChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary)),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: selected ? Colors.white : AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}