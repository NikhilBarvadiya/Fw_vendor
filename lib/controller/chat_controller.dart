import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/socket/index.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TextEditingController txtMessage = TextEditingController();
  ScrollController controller = ScrollController();
  dynamic loginData;

  @override
  void onInit() async {
    loginData = await getStorage(Session.userData);
    onChatting();
    super.onInit();
  }

  willPopScope() {
    Get.offNamed(AppRoutes.home);
  }

  onChatting() {
    socket.sendMessage(txtMessage.text);
    update();
  }
}
