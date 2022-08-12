import 'dart:convert';
import 'dart:developer';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/controller/chat_controller.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/model/message_model.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketServerController extends GetxController {
  late Socket socket;
  String connectionStatus = 'Not connected with server';
  void connectToServer() {
    try {
      // initializing
      socket = io(
        'http://admin.fastwhistle.com:3100',
        OptionBuilder().setTransports(['websocket']).enableAutoConnect().build(),
      );

      //connecting with server
      socket.connect();

      socket.onConnect((_) {
        log("Connected with socket channel");
        connectionStatus = 'Connected with server';
        socket.emit('init', 'vendor');
      });

      socket.on(
        'newChat',
        (message) async {
          log("Received notification by server 'newChat'");
          if (message != null && message != '') {
            message = jsonDecode(message);
            if (Get.isRegistered<ChatController>()) {
              ChatController chatController = Get.find();
              chatController.update();
            }
          }
        },
      );

      socket.on(
        'allChats',
        (message) async {
          log("Received notification by server 'allChats'");
          if (message != null && message != '') {
            message = jsonDecode(message);
            if (Get.isRegistered<ChatController>()) {
              ChatController chatController = Get.find();
              chatController.update();
            }
          }
        },
      );

      //disconnected with server
      socket.onDisconnect((_) {
        connectionStatus = 'Disconnected with server';
        log('disconnect');
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void sendMessage(String message) async {
    var loginData = await getStorage(Session.userData);
    if (message != '') {
      var messagePost = {
        "id": socket.id,
        'message': message,
        'sender': loginData["name"],
        'time': DateTime.now().toUtc().toString().substring(0, 16),
      };
      MessagesModel.messages.add(messagePost);
      socket.emit('message', messagePost);
    }
  }
}
