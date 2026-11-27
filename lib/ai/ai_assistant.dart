import 'package:flutter/material.dart';
import '../main.dart';
import 'chat_message.dart';
import 'ai_processor.dart';
import '../screens/medication_store.dart';
import '../screens/medication_tracker.dart'; // <--- THIS LINE IS CRITICAL

class AIColors {
  static const redDark = Color(0xFF7A0000);
  static const redMid = Color(0xFFB00000);
  static const redLight = Color(0xFFD10A0A);
  static const primary = Color(0xFFB30000);
  static const grayBubble = Color(0xFFF4F3F3);
  static const textDark = Color(0xFF111111);
  static const textMuted = Color(0xFF6B6B6B);
  static const border = Color(0xFFDDDDDD);
}

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});
  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final AIProcessor _processor = AIProcessor();
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
      _textController.clear();
    });
    _processor.processMessage(text).then((response) {
      setState(() { _isTyping = false; _messages.add(response); });
    });
  }

  @override
  void dispose() { _textController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AIColors.redDark, AIColors.redMid, AIColors.redLight]),
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
                    const Text('AI Assistant', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Medication help, privately', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: _messages.isEmpty ? _buildEmptyState() : _buildChatList()),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEAEAEA)))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                  Icon(Icons.lock_outline, size: 12, color: AIColors.textMuted),
                  SizedBox(width: 4),
                  Text('Processed on this device', style: TextStyle(fontSize: 10, color: AIColors.textMuted)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Message AI Assistant...',
                        hintStyle: const TextStyle(fontSize: 13, color: AIColors.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true, fillColor: const Color(0xFFF9F9F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AIColors.primary)),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_textController.text),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _textController.text.trim().isEmpty ? const Color(0xFFE0E0E0) : AIColors.primary,
                        shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AIColors.grayBubble, borderRadius: BorderRadius.circular(12)),
            child: const Text("Hi! I can log your doses and answer medication questions. What would you like to do?",
              style: TextStyle(fontSize: 13, color: AIColors.textDark)),
          ),
          const SizedBox(height: 20),
          const Text('TRY ASKING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AIColors.textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 10),
          _SuggestionChip(label: 'I took my medicine', onTap: () => _sendMessage('I took my medicine')),
          const SizedBox(height: 8),
          _SuggestionChip(label: 'Remind me at a time', onTap: () => _sendMessage('Remind me at a time')),
          const SizedBox(height: 8),
          _SuggestionChip(label: 'I missed a dose', onTap: () => _sendMessage('I missed a dose')),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) return _buildTypingIndicator();
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AIColors.grayBubble, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Understanding your message...', style: TextStyle(fontSize: 13, color: AIColors.textDark)),
          const SizedBox(height: 8),
          Row(mainAxisSize: MainAxisSize.min, children: const [
            _Dot(delay: 0), SizedBox(width: 4), _Dot(delay: 200), SizedBox(width: 4), _Dot(delay: 400),
          ]),
        ]),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(color: AIColors.primary,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12))),
          child: Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AIColors.grayBubble, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(msg.text, style: const TextStyle(fontSize: 13, color: AIColors.textDark)),
          if (msg.attachedMedication != null) ...[
            const SizedBox(height: 12),
            _MedicationCard(med: msg.attachedMedication!, status: msg.status),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => PhoneFrame(child: MedicationTrackerScreen())), (r) => false),
                style: OutlinedButton.styleFrom(foregroundColor: AIColors.primary,
                  side: const BorderSide(color: AIColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('View in Medication Tracker', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Not what you meant? You can edit this entry manually. For dose changes, please ask your care provider.",
              style: TextStyle(fontSize: 11, color: AIColors.textMuted, height: 1.4)),
          ],
        ]),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(border: Border.all(color: AIColors.border), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: const TextStyle(fontSize: 13, color: AIColors.primary, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Medication med;
  final String status;

  const _MedicationCard({required this.med, required this.status});

  @override
  Widget build(BuildContext context) {
    final s = med.strength.isNotEmpty ? med.strength : '';
    final t = med.times.isNotEmpty ? med.times.first : 'Unknown';
    final detail = s.isNotEmpty ? '$s • $t' : t;

    Color badgeColor;
    Color badgeTextColor;
    String badgeText;

    if (status == 'taken') {
      badgeColor = const Color(0xFFE8F5E9);
      badgeTextColor = const Color(0xFF2E7D32);
      badgeText = 'Taken';
    } else if (status == 'skipped') {
      badgeColor = const Color(0xFFFFF3E0);
      badgeTextColor = const Color(0xFFE65100);
      badgeText = 'Skipped';
    } else {
      badgeColor = const Color(0xFFECEFF1);
      badgeTextColor = const Color(0xFF546E7A);
      badgeText = 'Missed';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AIColors.border)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(med.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AIColors.textDark)),
          const SizedBox(height: 2),
          Text(detail, style: const TextStyle(fontSize: 12, color: AIColors.textMuted)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(4)),
          child: Text(badgeText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: badgeTextColor)),
        ),
      ]),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay; const _Dot({required this.delay});
  @override State<_Dot> createState() => _DotState();
}
class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
  late final Animation<double> _a = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  @override void initState() { super.initState(); Future.delayed(Duration(milliseconds: widget.delay), () { if(mounted) _c.repeat(reverse: true); }); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _a, builder: (c, ch) => Opacity(opacity: _a.value,
    child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: AIColors.textMuted, shape: BoxShape.circle))));
}