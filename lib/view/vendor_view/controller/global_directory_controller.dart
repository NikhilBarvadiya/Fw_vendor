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
  bool isSearch = true;
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

  var filters = {
    "area": {"id": "", "name": ""}
  };

  _onReset(String by) {
    if (by == "all") {
      filters = {
        "area": {"id": "", "name": ""},
      };
    } else {
      filters[by]!["id"] = "";
      filters[by]!["name"] = "";
    }
    update();
  }

  _onClean() {
    _onReset("all");
    globalAddressesList.clear();
    selectedOrderTrueList.clear();
    requestsList.clear();
    update();
  }

  willPopScope() {
    if (filters["area"]!["name"] != "") {
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

  onAreaModule() async {
    for (int i = 0; i < vendorAreaList.length; i++) {
      if (vendorAreaList[i]["selected"] == true) {
        vendorAreaList[i]['selected'] = false;
      }
      update();
    }
    await _vendorArea();
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

  onSelectDropdown(String id, String title, String forWhom) async {
    isLoading = true;
    if (forWhom == "area") {
      filters["area"]!["id"] = id;
      filters["area"]!["name"] = title;
    }
    for (int i = 0; i < vendorAreaList.length; i++) {
      if (vendorAreaList[i]["_id"] == filters["area"]!["id"]) {
        vendorAreaList[i]['selected'] = true;
      } else {
        vendorAreaList[i]['selected'] = false;
      }
      update();
    }
    if (filters["area"]!["id"] != null && filters["area"]!["id"] != "") {
      await _vendorGlobalAddresses();
      _autoSelector();
    }
    isLoading = false;
    update();
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
        "areaId": filters["area"]!["id"],
      };
      var resData = await apis.call(apiMethods.vendorGlobalAddresses, body, ApiType.post);
      if (resData.isSuccess && resData.data != 0) {
        globalAddressesList = resData.data["docs"];
        for (int i = 0; i < vendorAreaList.length; i++) {
          if (vendorAreaList[i]["selected"] == true) {
            vendorAreaList[i]['selected'] = false;
          }
          update();
        }
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
                  _onReset("all");
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
      var resData = await apis.call(apiMethods.vendorSaveAddress, data, ApiType.post);
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
