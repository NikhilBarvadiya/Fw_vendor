import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fw_vendor/controller/chat_controller.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
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
          body: Stack(
            children: [
              if (chatController.allChatList.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08),
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                    controller: chatController.controller,
                    shrinkWrap: true,
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: chatController.allChatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (chatController.allChatList[index]['fromId'] == chatController.loginData["_id"])
                          ? Slidable(
                              key: ValueKey(index),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) {},
                                    backgroundColor: Colors.black12,
                                    foregroundColor: Colors.black,
                                    label: chatController.loginData["name"].toString(),
                                  ),
                                ],
                              ),
                              child: ChatBubble(
                                elevation: 1,
                                clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                                alignment: Alignment.topRight,
                                margin: const EdgeInsets.only(top: 5, bottom: 5),
                                backGroundColor: Colors.yellow.shade100,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.maybeOf(context)!.size.width * 0.7),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getFormattedDate(chatController.allChatList[index]["updatedAt"].toString()),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        chatController.allChatList[index]["message"],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).paddingOnly(right: 5),
                              ),
                            )
                          : Slidable(
                              key: ValueKey(index),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) {},
                                    backgroundColor: Colors.black12,
                                    foregroundColor: Colors.black,
                                    label: "Admin",
                                  ),
                                ],
                              ),
                              child: ChatBubble(
                                elevation: 1,
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
                                        getFormattedDate(chatController.allChatList[index]["updatedAt"].toString()),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        chatController.allChatList[index]["message"],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).paddingOnly(left: 5),
                              ),
                            );
                    },
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatController.txtMessage,
                        decoration: const InputDecoration(
                          hintText: "Message",
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        style: const TextStyle(fontSize: 15),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                      ),
                      onPressed: () {
                        chatController.onChatting();
                      },
                    ),
                  ],
                ).paddingOnly(left: 20, right: 10, bottom: 20),
              ),
              if (chatController.allChatList.isEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    NoDataWidget(
                      title: "No data !",
                      body: "No orders available",
                    ),
                  ],
                ),
              if (chatController.isLoading && chatController.allChatList.isEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(.8),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
