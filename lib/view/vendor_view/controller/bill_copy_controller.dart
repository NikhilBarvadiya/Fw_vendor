import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class BillCopySettlementController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  bool isLoading = false;
  bool isSearch = true;
  String filterSelected = "Order No";
  int limit = 10;
  List billDetailsList = [];

  @override
  void onInit() async {
    _setBillDetails();
    super.onInit();
  }

  willPopScope() {
    Get.offNamed(AppRoutes.home);
  }

  List searchFilter = [
    {"title": "Order No", "_id": 1},
    {"title": "Bill No", "_id": 2},
    {"title": "Location Name", "_id": 3},
    {"title": "Amount", "_id": 4}
  ];

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onFilterSelected(String name) async {
    filterSelected = "";
    filterSelected = name;
    if (filterSelected != "") {
      Get.back();
      await _setBillDetails();
    }
    update();
  }

  onSearchOrders() async {
    txtSearchFocus.unfocus();
    await _setBillDetails();
    update();
  }

  void onRefresh() async {
    if (billDetailsList.length == limit) {
      limit = (billDetailsList.length) + 10;
      await _setBillDetails();
    }
  }

  _setBillDetails() async {
    try {
      isLoading = true;
      update();
      var data = {
        "fromDate": "",
        "toDate": "",
        "limit": limit,
        "page": 1,
        "search": txtSearch.text,
        "filterType": filterSelected,
      };
      var resData = await apis.call(
        apiMethods.setBillDetails,
        data,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        billDetailsList = resData.data["docs"];
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
