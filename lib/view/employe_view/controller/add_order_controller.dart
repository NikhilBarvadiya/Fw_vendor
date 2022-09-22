import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddOrderController extends GetxController {
  bool isLoading = false;
  TextEditingController txtAddress = TextEditingController();
  FocusNode txtAddressFocus = FocusNode();
  TextEditingController txtMobileNumber = TextEditingController();
  FocusNode txtMobileFocus = FocusNode();
  dynamic arguments;

  @override
  void onInit() {
    arguments = Get.arguments;
    super.onInit();
  }

  _screenFocus() {
    txtAddressFocus.unfocus();
    txtMobileFocus.unfocus();
  }

  _addOrder() async {
    try {
      isLoading = true;
      update();
      var request = {

      };
      log(request.toString());
      var resData = await apis.call(
        apiMethods.addOrder,
        request,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        isLoading = false;
        update();
        stylishDialog(
          context: Get.context,
          alertType: StylishDialogType.SUCCESS,
          contentText: "Add order success.",
          confirmButton: Colors.green,
          onPressed: () {
            Get.back();
            Get.offNamedUntil(AppRoutes.employeHome, (route) => false);
          },
        );
      }
    } catch (e) {
      isLoading = false;
      update();
      stylishDialog(
        context: Get.context,
        alertType: StylishDialogType.INFO,
        contentText: e.toString(),
        confirmButton: Colors.green,
        onPressed: () {
          Get.back();
        },
      );
    }
  }

  addOrderClick() {
    _screenFocus();
    //_addOrder();
    update();
  }
}
