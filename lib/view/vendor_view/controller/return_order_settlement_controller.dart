import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class ReturnOrderSettlementController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  bool isLoading = false;
  bool isSearch = false;
  int limit = 10;
  String selectedFilters = "";
  List returnOrderSettlementList = [];

  @override
  void onInit() async {
    _cashControllerStart();
    _screenFocus();
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

  _screenFocus() {
    txtSearch.text = "";
    txtSearchFocus.unfocus();
  }

  onChange(int i) {
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        selectedFilters = filters[a]["label"];
        _screenFocus();
      } else {
        filters[a]["isActive"] = false;
      }
    }
    _returnCalling();
    update();
  }

  _returnCalling() async {
    await _returnSettlement();
    update();
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onSearch() async {
    _screenFocus();
    await _returnSettlement();
    update();
  }

  void onRefresh() async {
    if (returnOrderSettlementList.length == limit) {
      limit = (returnOrderSettlementList.length) + 10;
      _screenFocus();
      await _returnSettlement();
    }
  }

  _returnSettlement() async {
    try {
      isLoading = true;
      update();
      var body = {
        "page": 0,
        "limit": limit,
        "search": txtSearch.text,
        "status": selectedFilters,
      };
      var resData = await apis.call(
        apiMethods.returnOrderSettlement,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        returnOrderSettlementList = resData.data["docs"];
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
