import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  bool isLoading = false;
  bool searchButton = false;
  String status = "";
  String filterSelected = "";
  List ordersDetailsList = [];

  @override
  void onInit() {
    status = Get.arguments;
    super.onInit();
  }

  List searchFilter = [
    {"title": "Order No", "_id": 1},
    {"title": "Bill No", "_id": 2},
    {"title": "Location Name", "_id": 3},
    {"title": "Amount", "_id": 4}
  ];

  onSearchButtonTapped() {
    if (searchButton && txtSearch.text != "") {
      txtSearch.text = "";
    }
    searchButton = !searchButton;
    update();
  }

  onFilterSelected(String name) {
    filterSelected = name;
    if (filterSelected != "") {
      _vendorOrders();
      Get.back();
    }
    update();
  }

  _vendorOrders() async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.vendorOrders,
        {
          "page": 1,
          "limit": 10,
          "searchType": filterSelected,
          "search": "",
          "status": status,
          "fromDate": "",
          "toDate": "",
        },
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        ordersDetailsList = resData.data["docs"];
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
}
