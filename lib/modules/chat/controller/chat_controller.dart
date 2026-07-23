import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isMe, required this.timestamp});
}

class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadMockMessages();
  }

  void _loadMockMessages() {
    messages.addAll([
      ChatMessage(
        text: "আসসালামু আলাইকুম, রফিক ভাই। খামারের অবস্থা কেমন?",
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        text: "ওয়ালাইকুম আসসালাম। আলহামদুলিল্লাহ, এখন সব ঠিক আছে।",
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ChatMessage(
        text: "পাখিদের ওজনে কোনো সমস্যা দেখছেন কি?",
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        text: "না, ওজন ঠিকঠাক বাড়ছে। কালকের এন্ট্রি চেক করলেই বুঝতে পারবেন।",
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ]);
  }

  void sendMessage() {
    if (textController.text.trim().isNotEmpty) {
      messages.add(ChatMessage(
        text: textController.text.trim(),
        isMe: true,
        timestamp: DateTime.now(),
      ));
      textController.clear();
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
