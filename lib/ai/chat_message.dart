import '../screens/medication_store.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final Medication? attachedMedication;
  final bool isTyping;
  final String status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachedMedication,
    this.isTyping = false,
    this.status = 'taken',
  });
}