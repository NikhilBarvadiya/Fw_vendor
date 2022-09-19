import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class CreateGlobalOrdersCntroller extends GetxController {
  bool isLoading = false;
  List vendorAreaList = [];
  List vendorAddressesByAreaList = [];
  List selectedOrderTrueList = [];
  String areaSelected = "";
  String areaSelectedId = "";

  @override
  void onInit() {
    _vendorArea();
    _autoSelector();
    super.onInit();
  }

  _onClean() {
    areaSelected = "";
    areaSelectedId = "";
    vendorAddressesByAreaList.clear();
    selectedOrderTrueList.clear();
    update();
  }

  willPopScope() {
    if (areaSelected != "") {
      _onClean();
      update();
    } else {
      Get.offNamedUntil(AppRoutes.home, (route) => false);
    }
  }

  _vendorArea() async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.vendorAreas,
        {},
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        vendorAreaList = resData.data;
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onRouteSelected(String name, String id) async {
    areaSelected = "";
    areaSelectedId = "";
    areaSelected = name;
    areaSelectedId = id;
    if (areaSelectedId != "") {
      onOpenArea();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      Get.back();
    }
    update();
  }

  onOpenArea() async {
    if (areaSelectedId != "" && areaSelected != "") {
      await _vendorAddressesByArea();
      _autoSelector();
    } else {}
  }

  _vendorAddressesByArea() async {
    try {
      isLoading = true;
      update();
      var data = {
        "areaId": areaSelected,
      };
      var resData = await apis.call(
        apiMethods.vendorAddressesByArea,
        data,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        vendorAddressesByAreaList = resData.data;
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onSelectedLocation() {
    if (selectedOrderTrueList.isNotEmpty) {
      Get.toNamed(AppRoutes.createGlobalOrdersDetailsScreen);
    } else {
      snackBar("No data selected", Colors.amber);
    }
    update();
  }

  addToSelectedList(item) {
    if (item != null) {
      var index = selectedOrderTrueList.indexOf(item);
      if (index == -1) {
        selectedOrderTrueList.add(item);
        update();
      } else {
        selectedOrderTrueList.remove(item);
        update();
      }
      _autoSelector();
    }
  }

  removeToSelectedList(item) {
    if (item != null) {
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
              onPressed: () {
                selectedOrderTrueList.remove(item);
                _autoSelector();
                Get.back();
                if (selectedOrderTrueList.isEmpty) {
                  areaSelected = "";
                  areaSelectedId = "";
                  Get.toNamed(AppRoutes.createGlobalOrdersScreen);
                }
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
  }

  _autoSelector() {
    for (int i = 0; i < vendorAddressesByAreaList.length; i++) {
      var data = selectedOrderTrueList.where((element) => element['_id'] == vendorAddressesByAreaList[i]['_id']);
      if (data.isNotEmpty) {
        vendorAddressesByAreaList[i]['selected'] = true;
      } else {
        vendorAddressesByAreaList[i]['selected'] = false;
      }
      update();
    }
  }

  onProceed(selectedAddress) {
    areaSelected = "";
    areaSelectedId = "";
    vendorAddressesByAreaList.clear();
    update();
    Get.toNamed(AppRoutes.placeOrderScreen, arguments: selectedAddress);
  }
}
