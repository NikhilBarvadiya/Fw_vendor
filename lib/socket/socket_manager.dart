import 'dart:developer';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/controller/chat_controller.dart';
import 'package:fw_vendor/controller/return_order_settlement_controller.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
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

      // chatting with server
      socket.on(
        'onNewMessage',
        (message) async {
          if (Get.isRegistered<ChatController>()) {
            ChatController chatController = Get.find();
            await chatController.getAllChats();
            chatController.update();
          }
        },
      );

      //return order settlement
      socket.on(
        'onReturnOTP',
        (data) async {
          if (Get.isRegistered<ReturnOrderSettlementController>()) {
            ReturnOrderSettlementController returnOrderSettlementController = Get.find();
            if (returnOrderSettlementController.selectedFilters != "") {
              await returnOrderSettlementController.onSearch();
              update();
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
      if (Get.isRegistered<ChatController>()) {
        ChatController chatController = Get.find();
        var messagePost = {
          "id": socket.id,
          'message': message,
          'sender': loginData["name"],
          'time': DateTime.now().toUtc().toString().substring(0, 16),
        };
        socket.emit('message', messagePost);
        chatController.update();
      }
    }
  }
}
