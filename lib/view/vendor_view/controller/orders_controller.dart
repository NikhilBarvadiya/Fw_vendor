import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  dynamic status;
  bool isLoading = false;
  bool isSearch = true;
  String filterSelected = "";
  List ordersDetailsList = [];
  String startDateVendor = "";
  String endDateVendor = "";
  dynamic locationData;
  int limit = 10;

  @override
  void onInit() async {
    status = Get.arguments;
    _orderControllerStart();
    txtSearchFocus.unfocus();
    super.onInit();
  }

  willPopScope() {
    Get.offNamedUntil(AppRoutes.home, (route) => false);
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

  onChange(int i) async {
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        status = filters[a]["label"];
        filterSelected = "";
        txtSearchFocus.unfocus();
      } else {
        filters[a]["isActive"] = false;
      }
    }
    await onSearchOrders();
    update();
  }

  _screenFocus() {
    txtSearch.clear();
    txtSearchFocus.unfocus();
    startDateVendor = "";
    endDateVendor = "";
  }

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
      await _vendorOrders();
    }
    update();
  }

  onSearchOrders() async {
    _screenFocus();
    await _vendorOrders();
    update();
  }

  void onRefresh() async {
    if (ordersDetailsList.length == limit) {
      limit = (ordersDetailsList.length) + 10;
      _screenFocus();
      await _vendorOrders();
    } else {
      _screenFocus();
      await _vendorOrders();
    }
    update();
  }

  customDate() {
    _screenFocus();
    Get.defaultDialog(
      title: "Select dates",
      barrierDismissible: false,
      onWillPop: () async {
        return true;
      },
      content: SizedBox(
        height: Get.height * 0.5,
        width: Get.width * 0.8,
        child: _customDatePicker(),
      ),
    );
  }

  _customDatePicker() {
    var config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
    );
    List<DateTime?> selectedDate = [];
    return CalendarDatePicker2WithActionButtons(
      config: config,
      initialValue: [
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      ],
      onValueChanged: (values) async {
        selectedDate = values;
        isLoading = true;
        update();
        startDateVendor =
            '${selectedDate[0]!.year}-${selectedDate[0]!.month.toString().padLeft(2, '0')}-${selectedDate[0]!.day.toString().padLeft(2, '0')}';
        endDateVendor =
            '${selectedDate[1]!.year}-${selectedDate[1]!.month.toString().padLeft(2, '0')}-${selectedDate[1]!.day.toString().padLeft(2, '0')}';
        await _vendorOrders();
        isLoading = false;
        update();
      },
      onCancelTapped: () {
        Get.back();
      },
    );
  }

  _vendorOrders() async {
    try {
      isLoading = true;
      update();
      var body = {
        "page": 1,
        "limit": limit,
        "searchType": filterSelected != "" ? filterSelected : "Order No",
        "search": txtSearch.text,
        "status": status ?? "pending",
        "fromDate": startDateVendor,
        "toDate": endDateVendor,
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
      snackBar("No package data found", Colors.red);
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
    _screenFocus();
    Get.toNamed(AppRoutes.locationScreen, arguments: data);
    update();
  }
}
