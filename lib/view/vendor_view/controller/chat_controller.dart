import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:fw_vendor/socket/index.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  TextEditingController txtMessage = TextEditingController();
  FocusNode txtMessageFocus = FocusNode();
  ScrollController controller = ScrollController();
  List allChatList = [];
  String messageType = "text";
  dynamic loginData;
  int limit = 20;
  bool isLoading = false;
  XFile? image;
  FilePickerResult? result;

  @override
  void onInit() async {
    loginData = await getStorage(Session.userData);
    getAllChats();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    txtMessageFocus.unfocus();
    super.onInit();
  }

  willPopScope() {
    Get.offNamedUntil(AppRoutes.home, (Route<dynamic> route) => false);
  }

  void _scrollListener() async {
    if (allChatList.length == limit) {
      limit = (allChatList.length) + 20;
      _screenFocus();
      await getAllChats();
    }
  }

  _screenFocus() {
    txtMessage.text = "";
    txtMessageFocus.unfocus();
  }

  void sendImage(source) async {
    ImagePicker imagePicker = ImagePicker();
    image = await imagePicker.pickImage(source: source);
    if (image != null) {
      messageType = "image";
      await _sendMessage();
    }
    await getAllChats();
    update();
  }

  void sendFile(type) async {
    result = await FilePicker.platform.pickFiles(type: type);
    if (result != null && result!.files.isNotEmpty) {
      if (type == FileType.any) {
        messageType = "file";
      }
      if (type == FileType.audio) {
        messageType = "audio";
      }
      await _sendMessage();
    }
    await getAllChats();
    update();
  }

  sendTextMessage() async {
    if (txtMessage.text != "") {
      messageType = "text";
      socket.sendMessage(txtMessage.text.toString());
      await _sendMessage();
    }
    await getAllChats();
    update();
  }

  _sendMessage() async {
    try {
      isLoading = true;
      update();
      dynamic file;
      if (image != null) {
        file = image;
      }
      if (result != null && result!.files.isNotEmpty) {
        file = result!.files.first;
      }
      dio.FormData formData = await _prepareDataToSend(messageType, txtMessage.text.toString(), file);
      isLoading = false;
      update();
      var response = await apis.call(apiMethods.sendMessageToAdmin, formData, ApiType.post);
      if (response.isSuccess == true && response.data != 0) {
        log("Message sent successfully!");
        messageType = "text";
        txtMessage.text = "";
        image = null;
        result = null;
        update();
      } else {
        log(response.message.toString());
      }
    } catch (err) {
      log(err.toString());
      messageType = "text";
      txtMessage.text = "";
      image = null;
      result = null;
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _prepareDataToSend(messageType, text, file) async {
    var requestJSON = {
      "messageType": messageType,
      "receiver": "admin",
    };
    if (messageType == "text") {
      requestJSON["message"] = text;
    }
    dio.FormData formData = dio.FormData.fromMap(requestJSON);
    if (file != null) {
      formData.files.add(
        MapEntry(
          "file",
          await dio.MultipartFile.fromFile(
            file.path.toString(),
            filename: file.path.toString().split("/").last,
          ),
        ),
      );
    }
    return formData;
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
