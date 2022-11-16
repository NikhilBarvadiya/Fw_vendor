import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class VerifyOrderController extends GetxController {
  dynamic arguments;
  TextEditingController txtShopName = TextEditingController();
  TextEditingController txtMobileNumber = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtBillNumber = TextEditingController();
  TextEditingController txtPKG = TextEditingController();
  FocusNode txtPKGFocus = FocusNode();
  TextEditingController txtBOX = TextEditingController();
  FocusNode txtBOXFocus = FocusNode();
  TextEditingController txtNote = TextEditingController();
  FocusNode txtNoteFocus = FocusNode();
  TextEditingController txtPersonName = TextEditingController();
  bool isLoading = false;
  bool isAdd = false;

  dynamic employeUserData;

  @override
  void onInit() {
    arguments = Get.arguments;
    employeUserData = getStorage(Session.employeUserData);
    txtShopName.text = arguments["data"]["globalAddressId"]["name"];
    txtMobileNumber.text = arguments["data"]["globalAddressId"]["mobile"];
    txtAddress.text = arguments["data"]["globalAddressId"]["address"];
    txtAmount.text = arguments["shopName"]["amount"] ?? "0";
    txtBillNumber.text = arguments["shopName"]["billNo"] ?? arguments["shopName"]["BillNo"];
    txtPersonName.text = arguments["data"]["globalAddressId"]["person"];
    txtPKG.text = "1";
    txtBOX.text = "0";
    txtNote.text = "";
    super.onInit();
  }

  _screenFocus() {
    txtPKGFocus.unfocus();
    txtBOXFocus.unfocus();
    txtNoteFocus.unfocus();
  }

  // Api calling.....

  _draftOrder() async {
    try {
      isLoading = true;
      update();
      var request = {
        "data": {
          "nOfPackages": txtPKG.text.toString(),
          "boxes": "0",
          "amount": txtAmount.text.toString(),
          "cash": "0",
          "billNo": txtBillNumber.text.toString(),
          "type": "credit",
          "nOfBoxes": txtBOX.text.toString(),
          "addressId": arguments["data"]["globalAddressId"]["_id"],
          "anyNote": txtNote.text.toString(),
          "orderType": "b2b",
          "vendorId": employeUserData["vendorId"]["_id"],
          "employeeId": employeUserData["_id"],
        },
        "isAdd": isAdd,
      };
      log(request.toString());
      var resData = await apis.call(
        apiMethods.draftOrder,
        request,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        isLoading = false;
        update();
        stylishDialog(
          context: Get.context,
          alertType: StylishDialogType.SUCCESS,
          contentText: "Add draft order success.",
          confirmButton: Colors.green,
          onPressed: () {
            Get.back();
            Get.offNamedUntil(AppRoutes.employeHome, (route) => false);
          },
        );
      } else {
        isLoading = false;
        update();
        stylishDialog(
          context: Get.context,
          alertType: StylishDialogType.INFO,
          contentText: "This bill number already in draft, You can increase PKG to update.",
          confirmButton: Colors.blue,
          onPressed: () {
            isAdd = true;
            update();
            Get.back();
          },
          cancelButton: false,
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

  draftOrderClick() async {
    _screenFocus();
    await _draftOrder();
    update();
  }
}
