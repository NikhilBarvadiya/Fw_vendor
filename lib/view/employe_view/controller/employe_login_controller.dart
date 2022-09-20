import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/snack_and_dialogs_utils.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class EmployeLoginController extends GetxController {
  final TextEditingController txtMobileNumber = TextEditingController();
  final focusMobileNumber = FocusNode();
  bool isLoading = false;

  void onLogin() async {
    try {
      isLoading = true;
      update();
      var request = {
        "mobile": txtMobileNumber.text,
      };
      var resData = await apis.call(
        apiMethods.employeLogin,
        request,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        await writeStorage(Session.employeUserData, resData.data);
        await writeStorage(Session.employeAuthToken, resData.data['token']);
        Get.toNamed(AppRoutes.employeHome);
      } else {
        errorDialog("Please try again ?");
      }
    } catch (e) {
      throw Exception("Failed to load users");
    }
    isLoading = false;
    update();
  }
}
