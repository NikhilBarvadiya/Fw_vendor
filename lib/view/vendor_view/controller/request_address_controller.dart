import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class RequestAddressControler extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  bool isLoading = false;
  bool isSearch = false;
  int limit = 10;
  List vendorRequestAddressList = [];

  @override
  void onInit() {
    _vendorRequestedAddress();
    super.onInit();
  }

  willPopScope() {
    Get.offNamed(AppRoutes.home);
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onSearchAddress() async {
    await _vendorRequestedAddress();
    update();
  }

  void onRefresh() async {
    if (vendorRequestAddressList.length == limit) {
      limit = (vendorRequestAddressList.length) + 10;
      await _vendorRequestedAddress();
    }
  }

  _vendorRequestedAddress() async {
    try {
      isLoading = true;
      update();
      var body = {
        "limit": limit,
        "page": 1,
        "search": txtSearch.text,
      };
      var resData = await apis.call(
        apiMethods.vendorRequestedAddress,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        vendorRequestAddressList = resData.data["docs"];
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _vendordeleteRequestedAddress(id) async {
    try {
      isLoading = true;
      update();
      var body = {
        "_id": id,
      };
      var resData = await apis.call(
        apiMethods.vendorDeleteRequestedAddress,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {}
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onRequestAddressDelete(id, address) async {
    isLoading = true;
    txtSearchFocus.unfocus();
    isLoading = false;
    Get.dialog(
      AlertDialog(
        title: Text(
          'Remove',
          style: AppCss.h1,
        ),
        content: Text(
          'Do you remove this address?',
          style: AppCss.h3,
        ),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () async {
              vendorRequestAddressList.remove(address);
              await _vendordeleteRequestedAddress(id);
              update();
              Get.back();
            },
          ),
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
    update();
  }

  onRequestAddressEdit(address) {
    txtSearchFocus.unfocus();
    Get.toNamed(AppRoutes.requestAddressEditScreen, arguments: address);
  }
}
