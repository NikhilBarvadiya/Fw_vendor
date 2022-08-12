import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/chat_controller.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return chatController.willPopScope();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            foregroundColor: Colors.white,
            title: const Text("Chat"),
          ),
        ),
      ),
    );
  }
}
