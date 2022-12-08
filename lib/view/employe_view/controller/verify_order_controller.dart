import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class VerifyOrderController extends GetxController {
  dynamic arguments;

  /// address
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

  /// request Address
  TextEditingController txtWhatsAppNumber = TextEditingController();
  FocusNode txtWhatsAppNumberFocus = FocusNode();
  FocusNode txtShopFocus = FocusNode();
  FocusNode txtAddressFocus = FocusNode();
  FocusNode txtMobileFocus = FocusNode();
  FocusNode txtBillNumberFocus = FocusNode();
  FocusNode txtAmountFocus = FocusNode();

  bool isLoading = false;
  bool isAdd = false;
  bool isError = false;

  dynamic employeUserData;

  @override
  void onInit() {
    arguments = Get.arguments;
    employeUserData = getStorage(Session.employeUserData);
    _checkValidation();
    super.onInit();
  }

  _checkValidation() {
    if (arguments["index"] == 0) {
      txtShopName.text = arguments["data"]["globalAddressId"]["name"];
      txtMobileNumber.text = arguments["data"]["globalAddressId"]["mobile"];
      txtAddress.text = arguments["data"]["globalAddressId"]["address"];
      txtAmount.text = arguments["scannerData"]["amount"] ?? "0";
      txtBillNumber.text = arguments["scannerData"]["billNo"] ?? arguments["scannerData"]["BillNo"];
      txtPersonName.text = arguments["data"]["globalAddressId"]["person"];
    } else if (arguments["index"] == 1) {
      txtShopName.text = arguments["scannerData"]["ShopName"].toString();
      txtAddress.text = arguments["scannerData"]["Address"].toString();
      txtMobileNumber.text = arguments["scannerData"]["Mobile"].toString();
      txtBillNumber.text = arguments["scannerData"]["BillNo"].toString();
      txtAmount.text = arguments["scannerData"]["Amount"] != null ? arguments["scannerData"]["Amount"].toString() : "0";
    }
    txtPKG.text = "1";
    txtBOX.text = "0";
    txtNote.text = "";
  }

  _screenFocus() {
    txtPKGFocus.unfocus();
    txtBOXFocus.unfocus();
    txtNoteFocus.unfocus();
    txtShopFocus.unfocus();
    txtAddressFocus.unfocus();
    txtMobileFocus.unfocus();
    txtBillNumberFocus.unfocus();
    txtAddressFocus.unfocus();
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
      var resData = await apis.call(apiMethods.draftOrder, request, ApiType.post);
      if (resData.isSuccess == true && resData.data != 0) {
        isLoading = false;
        update();
        successDialog(
          alertType: StylishDialogType.SUCCESS,
          contentText: "Add draft order success.",
          onPressed: () {
            Get.back();
            Get.offNamedUntil(AppRoutes.employeHome, (route) => false);
          },
        );
      } else {
        isLoading = false;
        update();
        infoDialog(
          contentText: "This bill number already in draft, You can increase PKG to update.",
          confirmButton: Colors.blue,
          onPressed: () {
            isAdd = true;
            update();
            Get.back();
          },
        );
      }
    } catch (e) {
      isLoading = false;
      update();
      infoDialog(
        contentText: e.toString(),
        confirmButton: Colors.green,
        onPressed: () {
          Get.back();
        },
      );
    }
  }

  _draftOrderWithRequestAddress() async {
    try {
      isLoading = true;
      update();
      var request = {
        "shopName": txtShopName.text.toString(),
        "address": txtAddress.text.toString(),
        "mobile": txtMobileNumber.text,
        "billNo": txtBillNumber.text,
        "amount": txtAmount.text,
        "whatsappNo": txtWhatsAppNumber.text.toString(),
        "loose": (txtPKG.text != 0.toString() || txtBOX.text != 0.toString()) ? txtPKG.text.toString() : "1",
        "box": txtBOX.text.toString(),
        "note": txtNote.text.toString(),
      };
      log(request.toString());
      var resData = await apis.call(apiMethods.addRequest, request, ApiType.post);
      if (resData.isSuccess == true && resData.data != 0) {
        isLoading = false;
        update();
        successDialog(
          alertType: StylishDialogType.SUCCESS,
          contentText: "Add request address success!",
          onPressed: () {
            Get.back();
            Get.offNamedUntil(AppRoutes.employeHome, (route) => false);
          },
        );
      }
    } catch (e) {
      isLoading = false;
      update();
      infoDialog(
        contentText: e.toString(),
        confirmButton: Colors.green,
        onPressed: () {
          Get.back();
        },
      );
    }
  }

  confirmClick() async {
    _screenFocus();
    if (arguments["index"] == 0) {
      await _draftOrder();
    } else {
      update();
      // if (txtShopName.text.isNotEmpty && txtAddress.text.isNotEmpty && txtBillNumber.text.isNotEmpty) {
      //   await _draftOrderWithRequestAddress();
      // } else {
      //   errorDialog(
      //     contentText: "Something wrong please try again!",
      //     onPressed: () {
      //       Get.back();
      //     },
      //   );
      // }
    }
    update();
  }
}
