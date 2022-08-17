import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class CashSettlementController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  bool isLoading = false;
  bool searchButton = false;
  String selectedFilters = "";
  List codSettlementList = [];
  int limit = 10;

  @override
  void onInit() async {
    _cashControllerStart();
    super.onInit();
  }

  List filters = [
    {
      "label": "pending",
      "isActive": true,
    },
    {
      "label": "completed",
      "isActive": false,
    },
  ];

  willPopScope() {
    Get.offNamed(AppRoutes.home);
  }

  _cashControllerStart() {
    onChange(0);
  }

  onChange(int i) {
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        selectedFilters = filters[a]["label"];
      } else {
        filters[a]["isActive"] = false;
      }
    }
    _cashCalling();
    update();
  }

  _cashCalling() async {
    await _codSettlement();
    update();
  }

  onSearchButtonTapped() {
    if (searchButton && txtSearch.text != "") {
      txtSearch.text = "";
    }
    searchButton = !searchButton;
    update();
  }

  onSearchAddress() async {
    await _codSettlement();
    update();
  }

  void onRefresh() async {
    if (codSettlementList.length == limit) {
      limit = (codSettlementList.length) + 10;
      await _codSettlement();
    }
  }

  _codSettlement() async {
    try {
      isLoading = true;
      update();
      var body = {
        "page": 0,
        "limit": limit,
        "search": txtSearch.text,
        "fromDate": "",
        "toDate": "",
        "status": selectedFilters,
      };
      var resData = await apis.call(
        apiMethods.codSettlement,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        codSettlementList = resData.data["docs"];
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
