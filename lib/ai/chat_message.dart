import 'package:flutter/material.dart';
import '../screens/medication_store.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final Medication? attachedMedication;
  final bool isTyping;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachedMedication,
    this.isTyping = false,
  });
}