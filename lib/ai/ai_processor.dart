import 'package:flutter/material.dart';
import 'dart:math';
import 'chat_message.dart';
import '../screens/medication_store.dart';

class AIProcessor {
  final MedicationStore _store = MedicationStore.instance;

  Future<ChatMessage> processMessage(String input) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final lowerInput = input.toLowerCase();
    final messageId = Random().nextInt(10000).toString();
    final now = DateTime.now();

    String? status;
    if (lowerInput.contains('missed') ||
        lowerInput.contains('skipped') ||
        lowerInput.contains('forgot') ||
        lowerInput.contains('didn\'t take') ||
        lowerInput.contains("didn't take")) {
      status = 'skipped';
    } else if (lowerInput.contains('took') ||
        lowerInput.contains('taken') ||
        lowerInput.contains('logged') ||
        lowerInput.contains('finished')) {
      status = 'taken';
    }

    if (status != null) {
      return _handleIntake(lowerInput, messageId, now, status);
    }

    if (lowerInput.contains('remind')) {
      return _handleReminder(input, messageId, now);
    }

    // NEW: Check if the message is just a time (response to "What time?")
    final timeOnly = _extractTimeFromText(input);
    if (timeOnly != null && !lowerInput.contains('took') && !lowerInput.contains('missed')) {
      return ChatMessage(
        id: messageId,
        text: "Got it. I'll remind you at ${_formatTime(timeOnly)}.",
        isUser: false,
        timestamp: now,
      );
    }

    return ChatMessage(
      id: messageId,
      text: "I'm not sure how to help with that yet. Try saying 'I took my medicine' or 'I missed a dose'.",
      isUser: false,
      timestamp: now,
    );
  }

  ChatMessage _handleReminder(String input, String id, DateTime time) {
    final picked = _extractTimeFromText(input);
    if (picked != null) {
      return ChatMessage(
        id: id,
        text: "Got it. I'll remind you at ${_formatTime(picked)}.",
        isUser: false,
        timestamp: time,
      );
    }
    return ChatMessage(
      id: id,
      text: "Sure. What time would you like the reminder? For example, 'Remind me at 8:30 PM'.",
      isUser: false,
      timestamp: time,
    );
  }

  TimeOfDay? _extractTimeFromText(String input) {
    final m = RegExp(r'(\d{1,2})(?::(\d{2}))?\s*(am|pm)?', caseSensitive: false).firstMatch(input);
    if (m == null) return null;

    final hour = int.tryParse(m.group(1)!);
    final minute = int.tryParse(m.group(2) ?? '0') ?? 0;
    final period = m.group(3)?.toLowerCase();
    if (hour == null || minute > 59) return null;

    int hour24;
    if (period == 'pm') {
      if (hour < 1 || hour > 12) return null;
      hour24 = hour == 12 ? 12 : hour + 12;
    } else if (period == 'am') {
      if (hour < 1 || hour > 12) return null;
      hour24 = hour == 12 ? 0 : hour;
    } else {
      if (hour < 0 || hour > 23) return null;
      hour24 = hour;
    }
    return TimeOfDay(hour: hour24, minute: minute);
  }

  String _formatTime(TimeOfDay t) {
    final period = t.hour < 12 ? 'AM' : 'PM';
    final h = t.hour % 12;
    final hourStr = h == 0 ? '12' : '$h';
    final minStr = t.minute.toString().padLeft(2, '0');
    return '$hourStr:$minStr $period';
  }

  ChatMessage _handleIntake(String input, String id, DateTime time, String status) {
    if (_store.items.isEmpty) {
      return ChatMessage(
        id: id,
        text: "You don't have any medications added yet. Add one first from the tracker.",
        isUser: false,
        timestamp: time,
      );
    }

    Medication? foundMed;
    for (final med in _store.items) {
      if (input.contains(med.name.toLowerCase())) {
        foundMed = med;
        break;
      }
    }
    if (foundMed == null) {
      foundMed = _findCurrentlyDueMedication();
    }

    if (foundMed == null) {
      return ChatMessage(
        id: id,
        text: "I couldn't find a medication that's due right now. Please specify which medication you're referring to.",
        isUser: false,
        timestamp: time,
      );
    }

    final scheduledTime = foundMed.times.isNotEmpty ? foundMed.times.first : 'Unknown';
    final log = IntakeLog(
      status: status,
      takenAt: 'Just now',
      note: 'Logged via AI Assistant',
    );
    _store.logIntake(foundMed.name, log, scheduledTime);

    final statusText = status == 'taken'
        ? 'logged this dose as taken'
        : 'marked this dose as skipped';

    return ChatMessage(
      id: id,
      text: "Got it. I $statusText in your tracker.",
      isUser: false,
      timestamp: time,
      attachedMedication: foundMed,
      status: status,
    );
  }

  Medication? _findCurrentlyDueMedication() {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    Medication? dueMed;
    int closestTimeDiff = 999999;

    for (final med in _store.items) {
      if (_store.todayLogs.containsKey(med.name)) continue;

      if (med.times.isNotEmpty) {
        final parsedTime = _parseTime(med.times.first);
        if (parsedTime != null) {
          final medMinutes = parsedTime.hour * 60 + parsedTime.minute;
          final diff = nowMinutes - medMinutes;
          if (diff > 0 && diff < closestTimeDiff) {
            closestTimeDiff = diff;
            dueMed = med;
          }
        }
      }
    }

    return dueMed;
  }

  TimeOfDay? _parseTime(String timeStr) {
    final parts = timeStr.trim().split(' ');
    if (parts.length != 2) return null;

    final timeParts = parts[0].split(':');
    if (timeParts.length != 2) return null;

    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    final period = parts[1].toUpperCase();

    if (hour == null || minute == null) return null;

    int hour24 = hour;
    if (period == 'PM' && hour != 12) hour24 = hour + 12;
    if (period == 'AM' && hour == 12) hour24 = 0;

    return TimeOfDay(hour: hour24, minute: minute);
  }
}