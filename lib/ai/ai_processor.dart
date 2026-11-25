import 'dart:math';
import 'chat_message.dart';
import '../screens/medication_store.dart';

class AIProcessor {
  final MedicationStore _store = MedicationStore.instance;

  Future<ChatMessage> processMessage(String input) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final lowerInput = input.toLowerCase();
    final messageId = Random().nextInt(10000).toString();
    final now = DateTime.now();

    if (lowerInput.contains('took') || lowerInput.contains('taken') || lowerInput.contains('logged')) {
      return _handleLogIntake(lowerInput, messageId, now, 'taken');
    }

    if (lowerInput.contains('missed') || lowerInput.contains('skipped') || lowerInput.contains('forgot')) {
      return _handleLogIntake(lowerInput, messageId, now, 'skipped');
    }

    if (lowerInput.contains('remind')) {
      return ChatMessage(
        id: messageId,
        text: "I've noted that. I'll remind you at the scheduled time.",
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

  ChatMessage _handleLogIntake(String input, String id, DateTime time, String status) {
    Medication? foundMed;
    String medName = "your medication";

    for (var med in _store.items) {
      if (input.contains(med.name.toLowerCase())) {
        foundMed = med;
        medName = med.name;
        break;
      }
    }

    if (foundMed == null && _store.items.isNotEmpty) {
      foundMed = _store.items.first;
      medName = foundMed.name;
    }

    if (foundMed != null) {
      final scheduledTime = foundMed.times.isNotEmpty ? foundMed.times.first : 'Unknown';
      final log = IntakeLog(
        status: status,
        takenAt: 'Just now',
        note: 'Logged via AI Assistant',
      );
      _store.logIntake(foundMed.name, log, scheduledTime);

      final statusText = status == 'taken' ? 'logged this dose' : 'marked this dose as skipped';
      
      return ChatMessage(
        id: id,
        text: "Got it. I $statusText in your tracker.",
        isUser: false,
        timestamp: time,
        attachedMedication: foundMed,
      );
    } else {
      return ChatMessage(
        id: id,
        text: "I couldn't find that medication in your list. Please add it first.",
        isUser: false,
        timestamp: time,
      );
    }
  }
}