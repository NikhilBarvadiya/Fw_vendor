import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class GlobalDirectoryController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  int limit = 10;
  bool isLoading = false;
  bool isSearch = false;
  String areaSelected = "";
  String areaSelectedId = "";
  List requestsList = [];
  List vendorAreaList = [];
  List selectedOrderTrueList = [];
  List globalAddressesList = [];

  @override
  void onInit() {
    _vendorArea();
    _autoSelector();
    txtSearchFocus.unfocus();
    super.onInit();
  }

  _onClean() {
    areaSelected = "";
    areaSelectedId = "";
    globalAddressesList.clear();
    selectedOrderTrueList.clear();
    requestsList.clear();
    update();
  }

  willPopScope() {
    if (areaSelected != "") {
      _onClean();
      update();
    } else {
      Get.offNamedUntil(AppRoutes.home, (Route<dynamic> route) => false);
    }
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onSearchGlobalAddress() async {
    txtSearchFocus.unfocus();
    await _vendorGlobalAddresses();
    update();
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
      await _vendorGlobalAddresses();
      _autoSelector();
    } else {}
  }

  _screenFocus() {
    isSearch = false;
    txtSearch.text = "";
    txtSearchFocus.unfocus();
    selectedOrderTrueList.clear();
  }

  void onRefresh() async {
    if (globalAddressesList.length == limit) {
      limit = (globalAddressesList.length) + 10;
      _screenFocus();
      await _vendorGlobalAddresses();
    } else {
      _screenFocus();
      await _vendorGlobalAddresses();
    }
  }

  _vendorGlobalAddresses() async {
    try {
      isLoading = true;
      update();
      var body = {
        "page": 1,
        "limit": limit,
        "search": txtSearch.text,
        "areaId": areaSelected,
      };
      var resData = await apis.call(
        apiMethods.vendorGlobalAddresses,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        globalAddressesList = resData.data["docs"];
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
      Get.toNamed(AppRoutes.globalDirectoryDetailsScreen);
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
        txtSearchFocus.unfocus();
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
                  Get.toNamed(AppRoutes.globalDirectoryScreen);
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
    requestsList = [];
    for (int i = 0; i < globalAddressesList.length; i++) {
      var data = selectedOrderTrueList.where((element) => element['_id'] == globalAddressesList[i]['_id']);
      if (data.isNotEmpty) {
        globalAddressesList[i]['selected'] = true;
        var globalAddressId = globalAddressesList[i]["_id"];
        requestsList.add({"globalAddressId": globalAddressId});
      } else {
        globalAddressesList[i]['selected'] = false;
        var globalAddressId = globalAddressesList[i]["_id"];
        requestsList.remove({"globalAddressId": globalAddressId});
      }
      update();
    }
  }

  _vendorSaveAddress() async {
    try {
      isLoading = true;
      update();
      var data = {
        "requests": requestsList,
      };
      var resData = await apis.call(
        apiMethods.vendorsaveAddress,
        data,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        _onClean();
        Get.back();
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

  onSaveLocation(context) async {
    if (selectedOrderTrueList.isNotEmpty) {
      await _vendorSaveAddress();
      stylishDialog(
        context: context,
        alertType: StylishDialogType.SUCCESS,
        titleText: 'Update success',
        contentText: "Address saved successfully!",
        confirmButton: Colors.green,
        onPressed: () {
          Get.back();
          update();
          Get.offNamed(AppRoutes.globalDirectoryScreen);
        },
      );
    }
  }
}
