import 'dart:convert';
import 'dart:developer';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/socket/index.dart';
import 'package:fw_vendor/view/vendor_view/controller/chat_controller.dart';
import 'package:fw_vendor/view/vendor_view/controller/return_order_settlement_controller.dart';
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
          if (message != null && message != '') {
            if (Get.isRegistered<ChatController>()) {
              ChatController chatController = Get.find();
              await chatController.getAllChats();
              chatController.update();
              if (message!['type'] == 'order_notification') {
                vendor.createNotificationOrder(
                  message!['title'],
                  message!['description'],
                  json.encode(
                    message!['data'],
                  ),
                );
              }
            }
          }
        },
      );

      //on sound notification received
      socket.on(
        'letsPlay',
        (data) async {
          log("Received notification by server");
          if (data != null && data != '') {
            data = jsonDecode(data);
            if (data!['type'] == 'order_notification') {
              vendor.createNotificationOrder(
                data!['title'],
                data!['description'],
                json.encode(
                  data!['data'],
                ),
              );
            }
          }
        },
      );

      //return order settlement
      socket.on(
        'onReturnOTP',
        (data) async {
          if (data != null && data != '') {
            data = jsonDecode(data);
            if (Get.isRegistered<ReturnOrderSettlementController>()) {
              ReturnOrderSettlementController returnOrderSettlementController = Get.find();
              returnOrderSettlementController.update();
              if (data['notification'] != null) {
                var notificationData = data['notification'];
                await vendor.showNormalNotification(
                  notificationData["title"],
                  notificationData["description"],
                  notificationData["payload"],
                );
              }
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
