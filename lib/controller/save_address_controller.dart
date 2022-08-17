import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class SaveAddressController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  List saveAddressList = [];
  List mappedAddressList = [];
  bool isLoading = false;
  bool isSearch = false;
  bool isMapper = false;
  int limit = 10;
  int limitMapper = 10;

  @override
  void onInit() {
    _vendorAddresses();
    super.onInit();
  }

  willPopScope() {
    if (isMapper == true) {
      isMapper = false;
      update();
    } else {
      Get.offNamed(AppRoutes.home);
    }
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onSearchAddress() async {
    await _vendorAddresses();
    update();
  }

  void onRefresh() async {
    if (saveAddressList.length == limit) {
      limit = (saveAddressList.length) + 10;
      await _vendorAddresses();
    }
  }

  _vendorAddresses() async {
    try {
      isLoading = true;
      update();
      var body = {
        "page": 1,
        "limit": limit,
        "search": txtSearch.text,
      };
      var resData = await apis.call(
        apiMethods.vendorAddresses,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        saveAddressList = resData.data["docs"];
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _vendorDeleteAddress(id) async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.vendorDeleteAddress,
        {
          "id": id,
        },
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

  onDeleteClick(address, id) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Remove',
          style: AppCss.h1,
        ),
        content: Text(
          'Do you remove this location?',
          style: AppCss.h3,
        ),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () async {
              saveAddressList.remove(address);
              await _vendorDeleteAddress(id);
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
  }

  onMapperButtonTapped() async {
    isMapper = !isMapper;
    await _vendorMappedAddress();
    update();
  }

  onMapperModeBack() async {
    isMapper = false;
    update();
    await _vendorAddresses();
  }

  onSearchMapperAddress() async {
    await _vendorMappedAddress();
    update();
  }

  void onRefreshMapper() async {
    if (mappedAddressList.length == limitMapper) {
      limitMapper = (mappedAddressList.length) + 10;
      await _vendorMappedAddress();
    }
  }

  _vendorMappedAddress() async {
    try {
      isLoading = true;
      update();
      var data = {
        "page": 1,
        "limit": limitMapper,
        "search": txtSearch.text,
        "filter": "database",
      };
      var resData = await apis.call(
        apiMethods.vendorMappedAddress,
        data,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        mappedAddressList = resData.data["result"]["docs"];
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _vendorDeleteMappedAddress(id) async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.vendorRemoveMappedAddress,
        {
          "id": id,
        },
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

  onDeleteMappedClick(address, id) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Remove',
          style: AppCss.h1,
        ),
        content: Text(
          'Do you remove this location?',
          style: AppCss.h3,
        ),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () async {
              mappedAddressList.remove(address);
              await _vendorDeleteMappedAddress(id);
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
  }

  _vendorToggleCreditCash(id) async {
    try {
      isLoading = true;
      update();
      var data = {
        "vendorAddressMapId": id,
      };
      var resData = await apis.call(
        apiMethods.vendorToggleCreditCash,
        data,
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

  onTypeClick(id) async {
    await _vendorToggleCreditCash(id);
    await _vendorMappedAddress();
    update();
  }
}
