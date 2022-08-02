import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  dynamic status;
  bool isLoading = false;
  bool searchButton = false;
  String filterSelected = "";
  List ordersDetailsList = [];

  @override
  void onInit() async {
    status = Get.arguments;
    _orderControllerStart();
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

  List filters = [
    {
      "label": "pending",
      "isActive": true,
    },
    {
      "label": "running",
      "isActive": false,
    },
    {
      "label": "completed",
      "isActive": false,
    },
    {
      "label": "cancelled",
      "isActive": false,
    },
  ];

  _orderControllerStart() {
    onChange(
      status == "pending"
          ? 0
          : status == "running"
              ? 1
              : status == "completed"
                  ? 2
                  : status == "cancelled"
                      ? 3
                      : 0,
    );
  }

  onChange(int i) {
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        status = filters[a]["label"];
        filterSelected = "";
      } else {
        filters[a]["isActive"] = false;
      }
    }
    _vendorOrdersCalling();
    update();
  }

  _vendorOrdersCalling() async {
    await _vendorOrders();
    update();
  }

  onSearchButtonTapped() {
    if (searchButton && txtSearch.text != "") {
      txtSearch.text = "";
    }
    searchButton = !searchButton;
    update();
  }

  onFilterSelected(String name) async {
    filterSelected = "";
    filterSelected = name;
    if (filterSelected != "") {
      Get.back();
      await _vendorOrders();
    }
    update();
  }

  _vendorOrders() async {
    try {
      isLoading = true;
      update();
      var body = {
        "page": 1,
        "limit": 10,
        "searchType": filterSelected != "" ? filterSelected : "Order No",
        "search": "",
        "status": status ?? "pending",
        "fromDate": "",
        "toDate": "",
      };
      var resData = await apis.call(
        apiMethods.vendorOrders,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        ordersDetailsList = resData.data["docs"];
        _reportPart();
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _reportPart() {
    for (var e in ordersDetailsList) {
      e['deliveryReport'] = _deliveryReport(e);
      for (int i = 0; i < e['deliveryReport']["delivered"].length; i++) {
        e["deliveredCount"] = e['deliveryReport']["delivered"][i]["status"].toString().capitalizeFirst;
      }
      for (int i = 0; i < e['deliveryReport']["running"].length; i++) {
        e["runningCount"] = e['deliveryReport']["running"][i]["status"].toString().capitalizeFirst;
      }
      for (int i = 0; i < e['deliveryReport']["returned"].length; i++) {
        e["returnedCount"] = e['deliveryReport']["returned"][i]["status"].toString().capitalizeFirst;
      }
      for (int i = 0; i < e['deliveryReport']["cancelled"].length; i++) {
        e["cancelledCount"] = e['deliveryReport']["cancelled"][i]["status"].toString().capitalizeFirst;
      }
    }
  }

  _deliveryReport(e) {
    List delivered = e["orderStatus"].where((a) => a['status'] == 'delivered').toList();
    List running = e["orderStatus"].where((a) => a['status'] == 'running').toList();
    List returned = e["orderStatus"].where((a) => a['status'] == 'returned').toList();
    List cancelled = e["orderStatus"].where((a) => a['status'] == 'cancelled').toList();
    dynamic output = {"delivered": delivered, "running": running, "returned": returned, "cancelled": cancelled};
    return output;
  }

  onLocationClick(data) {
    Get.toNamed(AppRoutes.locationScreen, arguments: data);
    update();
  }
}
