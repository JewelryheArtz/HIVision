import 'package:flutter/foundation.dart';

class Medication {
  final String name;
  final String amount;
  final String strength;
  final String instructions;
  final List<String> times;
  final String repeatLabel;
  final bool remindersOn;
  final DateTime startDate;
  final DateTime? endDate;

  const Medication({
    required this.name,
    required this.amount,
    required this.times,
    required this.repeatLabel,
    required this.remindersOn,
    required this.startDate,
    this.endDate,
    this.strength = '',
    this.instructions = '',
  });
}

class IntakeLog {
  final String status;
  final String takenAt;
  final String note;

  const IntakeLog({
    required this.status,
    required this.takenAt,
    required this.note,
  });
}

class HistoryEntry {
  final DateTime date;
  final String medicationName;
  final String scheduledTime;
  final String loggedAt;
  final String status;
  final String note;

  const HistoryEntry({
    required this.date,
    required this.medicationName,
    required this.scheduledTime,
    required this.loggedAt,
    required this.status,
    required this.note,
  });
}

class MedicationStore extends ChangeNotifier {
  MedicationStore._();
  static final MedicationStore instance = MedicationStore._();

  final List<Medication> _items = [];
  final Map<String, IntakeLog> _todayLogs = {};
  final List<HistoryEntry> _history = [];

  List<Medication> get items => List.unmodifiable(_items);
  Map<String, IntakeLog> get todayLogs => Map.unmodifiable(_todayLogs);
  List<HistoryEntry> get history => List.unmodifiable(_history);

  void add(Medication med) {
    _items.add(med);
    notifyListeners();
  }

  // NEW: Edit method to replace a medication at a given index
  void edit(int index, Medication med) {
    if (index >= 0 && index < _items.length) {
      _items[index] = med;
      notifyListeners();
    }
  }

  void logIntake(String medicationName, IntakeLog log, String scheduledTime) {
    _todayLogs[medicationName] = log;
    _history.add(HistoryEntry(
      date: DateTime.now(),
      medicationName: medicationName,
      scheduledTime: scheduledTime,
      loggedAt: log.takenAt,
      status: log.status,
      note: log.note,
    ));
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}