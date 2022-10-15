import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'dart:convert';

class CreateGlobalOrdersController extends GetxController {
  bool isLoading = false;
  bool isSearch = true;
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  List vendorAreaList = [];
  List vendorAddressesByAreaList = [];
  List selectedOrderTrueList = [];
  List filteredList = [];

  @override
  void onInit() {
    _vendorArea();
    _autoSelector();
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
    vendorAddressesByAreaList.clear();
    selectedOrderTrueList.clear();
    update();
  }

  _screenFocus() {
    isSearch = false;
    txtSearch.text = "";
    txtSearchFocus.unfocus();
  }

  willPopScope() {
    if (filters["area"]!["name"] != "") {
      _onClean();
      update();
    } else {
      Get.offNamedUntil(AppRoutes.home, (route) => false);
    }
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  filterSearch() {
    if (txtSearch.text == "") {
      filteredList.clear();
      filteredList = json.decode(json.encode(vendorAddressesByAreaList));
    } else {
      filteredList = vendorAddressesByAreaList
          .where((record) => record["globalAddressId"]["name"].toString().toLowerCase().contains(txtSearch.text.toLowerCase()))
          .toList();
    }
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
      var resData = await apis.call(apiMethods.vendorAreas, {}, ApiType.post);
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
      await _vendorAddressesByArea();
      _autoSelector();
    }
    isLoading = false;
    update();
  }

  _vendorAddressesByArea() async {
    try {
      isLoading = true;
      update();
      var data = {
        "areaId": filters["area"]!["id"],
      };
      var resData = await apis.call(apiMethods.vendorAddressesByArea, data, ApiType.post);
      if (resData.isSuccess && resData.data != 0) {
        vendorAddressesByAreaList = resData.data;
        filteredList = resData.data;
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
    _screenFocus();
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
                  _onReset("all");
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
    _onReset("all");
    vendorAddressesByAreaList.clear();
    update();
    Get.toNamed(AppRoutes.placeOrderScreen, arguments: selectedAddress);
  }
}
