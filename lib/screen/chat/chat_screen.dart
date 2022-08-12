import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:fw_vendor/controller/chat_controller.dart';
import 'package:fw_vendor/model/message_model.dart';
import 'package:fw_vendor/socket/index.dart';
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
            title: Text("${MessagesModel.messages.length}"),
          ),
          body: Stack(
            children: [
              ListView.builder(
                controller: chatController.controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                reverse: true,
                cacheExtent: 1000,
                itemCount: MessagesModel.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  var message = MessagesModel.messages[MessagesModel.messages.length - index - 1];
                  print(message);
                  return (message['sender'] == chatController.loginData["name"])
                      ? ChatBubble(
                          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          backGroundColor: Colors.yellow[100],
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.maybeOf(context)!.size.width * 0.7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${message['time']}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '${message['message']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ChatBubble(
                          clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          backGroundColor: Colors.grey[100],
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.maybeOf(context)!.size.width * 0.7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${message['sender']} ${message['time']}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '${message['message']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatController.txtMessage,
                        decoration: const InputDecoration(
                          hintText: "Message",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          counterText: '',
                        ),
                        style: const TextStyle(fontSize: 15),
                        keyboardType: TextInputType.text,
                        maxLength: 500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        chatController.onChatting();
                      },
                    ),
                  ],
                ),
              ).paddingOnly(bottom: 20, left: 20, right: 20),
            ],
          ),
        ),
      ),
    );
  }
}
