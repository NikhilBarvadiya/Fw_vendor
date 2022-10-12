import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class TicketsController extends GetxController {
  dynamic status;
  bool isLoading = false;
  bool isNoteFilled = false;
  TextEditingController txtNotes = TextEditingController();
  FocusNode txtNameFocus = FocusNode();
  List<File> selectedFileList = [];
  File? audioNote;
  bool isRecorded = false;
  String audioPath = "";
  List constantData = [
    "Package not available.!",
    "Package is damage.!",
  ];

  final picker = ImagePicker();

  @override
  void onInit() {
    status = Get.arguments;
    super.onInit();
  }

  delete(img) {
    selectedFileList.remove(img);
    update();
  }

  getImage(ImageSource source) async {
    isLoading = true;
    update();
    XFile? image = await picker.pickImage(source: source, imageQuality: 80, maxHeight: 1350, maxWidth: 1080);
    if (image != null) {
      File file = File(image.path);
      selectedFileList.add(file);
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  setAudioFile(String path) {
    return File(path);
  }

  void setNote(value) async {
    txtNotes.text = value;
    isNoteFilled = true;
    update();
  }

  onReturnOrderDetails() async {
    try {
      isLoading = true;
      update();
      var request = {
        "desc": txtNotes.text,
        "addressId": status["location"]["addressId"] != null ? status["location"]["addressId"]["_id"] : status["location"]["_id"],
        "vendorOrderId": status["ordersDetails"] != null ? status["location"]["vendorOrderId"] : status["location"]["vendorOrderId"]["_id"],
        "vendorOrderStatusId": status["location"]["_id"],
        "vendorOrderNo": status["ordersDetails"] != null ? status["ordersDetails"]["orderNo"] : status["location"]["vendorOrderId"]["orderNo"],
        "billNo": status["location"]["billNo"],
      };
      dio.FormData formData = dio.FormData.fromMap(request);
      if (selectedFileList.isNotEmpty) {
        for (int i = 0; i < selectedFileList.length; i++) {
          String path = selectedFileList[i].path;
          String imageName = selectedFileList[i].path.split('/').last;
          formData.files.add(
            MapEntry(
              "images",
              await dio.MultipartFile.fromFile(path, filename: imageName.toString()),
            ),
          );
        }
      }
      if (audioPath.isNotEmpty) {
        String notePath = audioNote!.path;
        String noteName = audioNote!.path.split('/').last;
        formData.files.add(
          MapEntry(
            "audioNote",
            await dio.MultipartFile.fromFile(notePath, filename: noteName.toString()),
          ),
        );
      }
      if (txtNotes.text != "") {
        var response = await apis.call(apiMethods.setOrderTicket, formData, ApiType.post);
        if (response.isSuccess == true) {
          successDialog(
            contentText: response.message.toString(),
            onPressed: () {
              status["ordersDetails"] != null
                  ? Get.offNamedUntil(AppRoutes.orders, (route) => false)
                  : Get.offNamedUntil(AppRoutes.complaintScreen, (route) => false);
            },
          );
        } else {
          warningDialog(contentText: response.message.toString(), onPressed: () => Get.back());
        }
      } else {
        infoDialog(contentText: "Description not found", titleText: "Please try again!", onPressed: () => Get.back());
        isLoading = false;
        update();
      }
    } catch (e) {
      errorDialog(contentText: e.toString(), onPressed: () => Get.back());
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }
}
