import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/controller/orders_create_controller.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class ShowAddressBookController extends GetxController {
  final ordersCreateController = Get.find<OrdersCreateController>();
  TextEditingController txtSearch = TextEditingController();
  bool isLoading = false;
  bool isSearch = false;
  int limit = 10;
  List getCustomerAddressList = [];

  @override
  void onInit() {
    _saveCustomerAddress();
    super.onInit();
  }

  willPopScope() {
    Get.back();
    update();
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onSearchAddress() async {
    await _saveCustomerAddress();
    update();
  }

  void onRefresh() async {
    if (getCustomerAddressList.length == limit) {
      limit = (getCustomerAddressList.length) + 10;
      await _saveCustomerAddress();
    }
  }

  _saveCustomerAddress() async {
    try {
      isLoading = true;
      update();
      var body = {
        "search": txtSearch.text,
        "page": 1,
        "limit": limit,
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

  _deleteCustomerAddress(addressId) async {
    try {
      isLoading = true;
      update();
      var body = {"addressId": addressId};
      var resData = await apis.call(
        apiMethods.deleteCustomerAddress,
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

  onEdit(addressData) {
    ordersCreateController.txtName.text = addressData["name"];
    ordersCreateController.txtAdress.text = addressData["address"];
    ordersCreateController.txtMobile.text = addressData["mobile"];
    var data = "${addressData["lat"]},${addressData["lng"]}";
    ordersCreateController.txtLatLng.text = data;
    ordersCreateController.txtBillNo.text = "0";
    ordersCreateController.txtAmount.text = "0";
    ordersCreateController.txtBillAmount.text = "0";
    ordersCreateController.txtLoosePkg.text = "0";
    ordersCreateController.txtBoxPkg.text = "0";
    ordersCreateController.txtNotes.text = "-";
    update();
    Get.offNamed(AppRoutes.ordersFromScreen);
  }

  onDeleteOrders(addressId) {
    if (addressId != null) {
      Get.dialog(
        AlertDialog(
          title: Text(
            'Delete',
            style: AppCss.h1,
          ),
          content: Text(
            'Do you really want to delete this address?',
            style: AppCss.h3,
          ),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                _deleteCustomerAddress(addressId);
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
  }
}
