import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_notes.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class DraftOrdersController extends GetxController {
  TextEditingController txtNotes = TextEditingController();
  TextEditingController txtAddressName = TextEditingController();
  TextEditingController txtAdress = TextEditingController();
  TextEditingController txtLoosePkg = TextEditingController();
  TextEditingController txtBoxPkg = TextEditingController();
  TextEditingController txtBillNo = TextEditingController();
  TextEditingController txtBillAmount = TextEditingController();
  TextEditingController txtAmount = TextEditingController();
  bool isLoading = false;
  List getDraftOrderList = [];
  List selectedOrderList = [];
  dynamic editData;
  @override
  void onInit() {
    _getVendorDraftOrder();
    _autoSelector();
    super.onInit();
  }

  willPopScope() {
    selectedOrderList.clear();
    update();
    Get.offNamed(AppRoutes.home);
  }

  _getVendorDraftOrder() async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.getVendorDraftOrder,
        {},
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        getDraftOrderList = resData.data;
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _updateVendorDraftOrder(item) async {
    try {
      isLoading = true;
      update();
      var data = {
        "addressId": {
          "address": txtAdress.text != "" ? txtAdress.text : item["addressId"]["address"].toString(),
          "businessCategoryId": item["addressId"]["businessCategoryId"].toString(),
          "createdAt": item["addressId"]["createdAt"].toString(),
          "flatFloorBuilding": item["addressId"]["flatFloorBuilding"].toString(),
          "isDeleted": item["addressId"]["isDeleted"].toString(),
          "lat": item["addressId"]["lat"].toString(),
          "lng": item["addressId"]["lng"].toString(),
          "mobile": item["addressId"]["mobile"].toString(),
          "name": txtAddressName.text != "" ? txtAddressName.text : item["addressId"]["name"].toString(),
          "person": item["addressId"]["person"].toString(),
          "routeId": item["addressId"]["routeId"]["_id"].toString(),
          "shortNo": item["addressId"]["shortNo"].toString(),
          "updatedAt": item["addressId"]["updatedAt"].toString(),
          "_id": item["addressId"]["_id"],
        },
        "amount": txtBillAmount.text != "" ? txtBillAmount.text : item["amount"].toString(),
        "anyNote": txtNotes.text != "" ? txtNotes.text.toString() : "",
        "billNo": txtBillNo.text != "" ? txtBillNo.text : item["billNo"].toString(),
        "boxes": item["boxes"].toString(),
        "cash": txtAmount.text != "" ? txtAmount.text : item["cash"].toString(),
        "createdAt": item["cash"].toString(),
        "isSelected": item["isSelected"].toString(),
        "nOfBoxes": txtBoxPkg.text != "" ? txtBoxPkg.text : item["nOfBoxes"].toString(),
        "nOfPackages": txtLoosePkg.text != "" ? txtLoosePkg.text : item["nOfPackages"].toString(),
        "orderType": item["orderType"].toString(),
        "type": item["type"].toString(),
        "updatedAt": item["updatedAt"].toString(),
        "vendorId": item["vendorId"].toString(),
        "_id": item["_id"],
      };
      var resData = await apis.call(
        apiMethods.updateVendorDraftOrder,
        {
          "data": data,
        },
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        var index = getDraftOrderList.indexOf(item);
        getDraftOrderList.remove(item);
        getDraftOrderList.insert(index, data);
        update();
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onNotes(item, context) async {
    stylishDialog(
      context: context,
      alertType: StylishDialogType.NORMAL,
      titleText: "Message",
      contentText: "Do you Delete this orders?",
      txtCancelButton: "Reset",
      confirmButton: Colors.green,
      cancelButtonColor: Colors.redAccent,
      addView: customNotesText(
        controller: txtNotes,
        hintText: "Type your message here......",
        height: 100,
      ),
      cancelButton: true,
      onCancel: () {
        txtNotes.clear();
        update();
        Get.back();
      },
      onPressed: () async {
        Get.back();
        await _updateVendorDraftOrder(item);
      },
    );
  }

  onLocationUpdate(item, context) async {
    stylishDialog(
      context: context,
      alertType: StylishDialogType.INFO,
      titleText: "Update",
      contentText: "Do you update this orders?",
      txtCancelButton: "Reset",
      confirmButton: Colors.green,
      cancelButtonColor: Colors.redAccent,
      cancelButton: true,
      onCancel: () {
        Get.back();
      },
      onPressed: () async {
        selectedOrderList.clear();
        update();
        Get.back();
        await _updateVendorDraftOrder(item);
        Get.offNamed(AppRoutes.draftOrdersScreen);
      },
    );
  }

  onEdit(item) {
    editData = item;
    txtAddressName.text = item["addressId"]["name"].toString();
    txtAdress.text = item["addressId"]["address"].toString();
    txtBillNo.text = item["billNo"].toString();
    txtBillAmount.text = item["amount"].toString();
    txtAmount.text = item["cash"].toString();
    txtLoosePkg.text = item["nOfPackages"].toString();
    txtBoxPkg.text = item["nOfBoxes"].toString();
    txtNotes.text = item["anyNote"].toString();
    update();
    Get.toNamed(AppRoutes.editSelectedLocationScreen);
  }

  onDeleteorders(item, context) {
    if (item != null) {
      stylishDialog(
        context: context,
        alertType: StylishDialogType.ERROR,
        titleText: "Delete",
        contentText: "Do you Delete this orders?",
        confirmButton: Colors.redAccent,
        onPressed: () {
          Get.back();
        },
      );
    }
  }

  addToSelectedList(item, context) {
    if (item != null) {
      var index = selectedOrderList.indexOf(item);
      if (index == -1) {
        selectedOrderList.add(item);
        update();
      } else {
        selectedOrderList.remove(item);
        update();
      }
      _autoSelector();
    }
  }

  _autoSelector() {
    for (int i = 0; i < getDraftOrderList.length; i++) {
      var data = selectedOrderList.where((element) => element['_id'] == getDraftOrderList[i]['_id']);
      if (data.isNotEmpty) {
        getDraftOrderList[i]['selected'] = true;
      } else {
        getDraftOrderList[i]['selected'] = false;
      }
      update();
    }
  }

  onProceed(arguments) {
    Get.offNamed(AppRoutes.placeOrderScreen, arguments: arguments);
    update();
  }
}
