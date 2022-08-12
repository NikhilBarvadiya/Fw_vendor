import 'dart:convert';
import 'dart:developer';
import 'package:fw_vendor/controller/home_controller.dart';
import 'package:fw_vendor/socket/index.dart';
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
        'onHomeRefresh',
        (data) async {
          log("Received notification by server 'onHomeRefresh'");
          if (data != null && data != '') {
            data = jsonDecode(data);
            if (Get.isRegistered<HomeController>()) {
              HomeController homeController = Get.find();
              homeController.vendorWhoAmI();
              update();
            }
            if (data['notification'] != null) {
              var notificationData = data['notification'];
              await manager.showNormalNotification(
                notificationData["title"],
                notificationData["description"],
                notificationData["payload"],
              );
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
}
