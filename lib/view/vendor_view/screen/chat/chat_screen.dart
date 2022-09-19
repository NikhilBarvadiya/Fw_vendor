import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/env.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/chat_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/link.dart';

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
              Container(
                color: Colors.white.withOpacity(.8),
                child: Image.asset(
                  imageAssets.whatsApp,
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
              if (chatController.allChatList.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.085),
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                    controller: chatController.controller,
                    shrinkWrap: true,
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: chatController.allChatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (chatController.allChatList[index]['fromId'] == chatController.loginData["_id"])
                          ? ChatBubble(
                              elevation: 1,
                              clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                              alignment: Alignment.topRight,
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              backGroundColor: Colors.grey.shade800,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.maybeOf(context)!.size.width * 0.7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (chatController.allChatList[index]["messageType"] == "text" && chatController.allChatList[index]["message"] != "")
                                      Text(
                                        chatController.allChatList[index]["message"].toString().capitalizeFirst.toString(),
                                        style: AppCss.body1.copyWith(color: Colors.white),
                                      ),
                                    if (chatController.allChatList[index]["messageType"] == "image" && chatController.allChatList[index]["message"] != "")
                                      SizedBox(
                                        height: 130,
                                        width: 130,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              builder: (BuildContext context) => Container(
                                                color: Colors.black,
                                                child: AlertDialog(
                                                  backgroundColor: Colors.black,
                                                  insetPadding: const EdgeInsets.all(2),
                                                  title: SizedBox(
                                                    height: MediaQuery.of(context).size.height / 2,
                                                    width: MediaQuery.of(context).size.width,
                                                    child: InteractiveViewer(
                                                      child: Image.network(
                                                        environment["imagesbaseUrl"] + chatController.allChatList[index]["message"].toString(),
                                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                          if (loadingProgress == null) {
                                                            return child;
                                                          }
                                                          return Center(
                                                            child: CircularProgressIndicator(
                                                              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              context: context,
                                            );
                                          },
                                          child: Image.network(
                                            environment["imagesbaseUrl"] + chatController.allChatList[index]["message"].toString(),
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ).paddingOnly(top: 5),
                                    if (chatController.allChatList[index]["messageType"] == "file" || chatController.allChatList[index]["messageType"] == "audio" && chatController.allChatList[index]["message"] != "")
                                      Link(
                                        uri: Uri.parse(
                                          environment["imagesbaseUrl"] + chatController.allChatList[index]["message"],
                                        ),
                                        target: LinkTarget.blank,
                                        builder: (BuildContext ctx, FollowLink? openLink) {
                                          return TextButton.icon(
                                            onPressed: openLink,
                                            label: Text(
                                              chatController.allChatList[index]["messageType"] == "file"
                                                  ? 'Show file'
                                                  : chatController.allChatList[index]["messageType"] == "audio"
                                                      ? 'Show audio'
                                                      : "",
                                              style: AppCss.body1.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                            icon: Icon(
                                              chatController.allChatList[index]["messageType"] == "file"
                                                  ? FontAwesomeIcons.solidFile
                                                  : chatController.allChatList[index]["messageType"] == "audio"
                                                      ? Icons.audiotrack
                                                      : null,
                                              color: chatController.allChatList[index]["messageType"] == "file"
                                                  ? Colors.amber
                                                  : chatController.allChatList[index]["messageType"] == "audio"
                                                      ? Colors.red
                                                      : null,
                                            ),
                                          );
                                        },
                                      ),
                                    Text(
                                      getFormattedDate(chatController.allChatList[index]["updatedAt"].toString()),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ).paddingOnly(top: 5),
                                  ],
                                ).paddingOnly(right: 5),
                              ),
                            )
                          : ChatBubble(
                              elevation: 1,
                              clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              backGroundColor: const Color(0xFFEEEEEE),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.maybeOf(context)!.size.width * 0.7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (chatController.allChatList[index]["messageType"] == "text" && chatController.allChatList[index]["message"] != "")
                                      Text(
                                        chatController.allChatList[index]["message"],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    if (chatController.allChatList[index]["messageType"] == "image" && chatController.allChatList[index]["message"] != "")
                                      SizedBox(
                                        height: 130,
                                        width: 130,
                                        child: Image.network(
                                          environment["imagesbaseUrl"] + chatController.allChatList[index]["message"].toString(),
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ).paddingOnly(top: 5),
                                    if (chatController.allChatList[index]["messageType"] == "file" || chatController.allChatList[index]["messageType"] == "audio" && chatController.allChatList[index]["message"] != "")
                                      Link(
                                        uri: Uri.parse(
                                          environment["imagesbaseUrl"] + chatController.allChatList[index]["message"],
                                        ),
                                        target: LinkTarget.blank,
                                        builder: (BuildContext ctx, FollowLink? openLink) {
                                          return TextButton.icon(
                                            onPressed: openLink,
                                            label: Text(
                                              chatController.allChatList[index]["messageType"] == "file"
                                                  ? 'Show file'
                                                  : chatController.allChatList[index]["messageType"] == "audio"
                                                      ? 'Show audio'
                                                      : "",
                                              style: AppCss.body1.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                            icon: Icon(
                                              chatController.allChatList[index]["messageType"] == "file"
                                                  ? FontAwesomeIcons.solidFile
                                                  : chatController.allChatList[index]["messageType"] == "audio"
                                                      ? Icons.audiotrack
                                                      : null,
                                              color: chatController.allChatList[index]["messageType"] == "file"
                                                  ? Colors.amber
                                                  : chatController.allChatList[index]["messageType"] == "audio"
                                                      ? Colors.red
                                                      : null,
                                            ),
                                          );
                                        },
                                      ),
                                    Text(
                                      getFormattedDate(chatController.allChatList[index]["updatedAt"].toString()),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ).paddingOnly(top: 5),
                                  ],
                                ),
                              ).paddingOnly(left: 5),
                            );
                    },
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      SpeedDial(
                        overlayColor: Colors.transparent,
                        icon: Icons.add,
                        elevation: 0,
                        activeIcon: Icons.close,
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        activeBackgroundColor: Theme.of(context).primaryColor,
                        activeForegroundColor: Colors.white,
                        children: [
                          SpeedDialChild(
                            onTap: () => chatController.sendImage(ImageSource.camera),
                            child: Icon(
                              FontAwesomeIcons.camera,
                              color: Colors.grey.shade800,
                              size: 18,
                            ),
                          ),
                          SpeedDialChild(
                            onTap: () => chatController.sendImage(ImageSource.gallery),
                            child: Icon(
                              FontAwesomeIcons.images,
                              color: Colors.grey.shade800,
                              size: 18,
                            ),
                          ),
                          SpeedDialChild(
                            onTap: () => chatController.sendFile(FileType.any),
                            child: Icon(
                              FontAwesomeIcons.file,
                              color: Colors.grey.shade800,
                              size: 18,
                            ),
                          ),
                          SpeedDialChild(
                            onTap: () => chatController.sendFile(FileType.audio),
                            child: Icon(
                              FontAwesomeIcons.music,
                              color: Colors.grey.shade800,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TextField(
                          controller: chatController.txtMessage,
                          decoration: const InputDecoration(
                            hintText: "Message",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          cursorHeight: 20,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      IconButton(
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          chatController.sendTextMessage();
                        },
                      ),
                    ],
                  ),
                ),
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
