import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class ShowAddressBookController extends GetxController {
  bool isLoading = false;
  List getCustomerAddressList = [];

  @override
  void onInit() {
    _saveCustomerAddress();
    super.onInit();
  }

  _saveCustomerAddress() async {
    try {
      isLoading = true;
      update();
      var body = {
        "search": "",
        "page": 1,
        "limit": 10,
      };
      var resData = await apis.call(
        apiMethods.getCustomerAddress,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        getCustomerAddressList = resData.data["docs"];
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }
}
