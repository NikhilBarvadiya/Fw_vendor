import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:fw_vendor/socket/index.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TextEditingController txtMessage = TextEditingController();
  ScrollController controller = ScrollController();
  List allChatList = [];
  dynamic loginData;
  int limit = 20;
  bool isLoading = false;

  @override
  void onInit() async {
    loginData = await getStorage(Session.userData);
    getAllChats();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    super.onInit();
  }

  willPopScope() {
    Get.offNamed(AppRoutes.home);
  }

  void _scrollListener() async {
    if (allChatList.length == limit) {
      limit = (allChatList.length) + 20;
      await getAllChats();
    }
  }

  onChatting() async {
    if (txtMessage.text != "") {
      socket.sendMessage(txtMessage.text.toString());
      await sendMessageToAdmin();
      txtMessage.text = "";
      update();
    }
    await getAllChats();
    update();
  }

  sendMessageToAdmin() async {
    try {
      isLoading = true;
      update();
      if (txtMessage.text != "") {
        var data = {
          "message": txtMessage.text,
          "messageType": "text",
          "receiver": "admin",
        };
        var resData = await apis.call(
          apiMethods.sendMessageToAdmin,
          data,
          ApiType.post,
        );
        if (resData.isSuccess && resData.data != 0) {
          allChatList = resData.data["docs"];
        }
      }
    } catch (e) {
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  getAllChats() async {
    try {
      isLoading = true;
      update();
      var data = {
        "limit": limit,
        "page": 1,
      };
      var resData = await apis.call(
        apiMethods.getAllChats,
        data,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        allChatList = resData.data["docs"];
      }
    } catch (e) {
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }
}
