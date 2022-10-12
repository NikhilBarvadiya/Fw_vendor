import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class ReturnOrdersController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  int limit = 15;
  bool isLoading = false;
  bool isSearch = true;
  bool isFilter = true;
  bool isRoutesON = false;
  String startDateVendor = "";
  String endDateVendor = "";
  List returnOrderDetailsList = [];
  List vendorRoutesList = [];
  List routeIdList = [];

  @override
  void onInit() async {
    getReturnOrderDetails();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  willPopScope() {
    Get.offNamedUntil(AppRoutes.home, (route) => false);
  }

  var filters = {
    "route": {"id": "", "name": ""}
  };

  _onReset(String by) {
    if (by == "all") {
      filters = {
        "route": {"id": "", "name": ""},
      };
    } else {
      filters[by]!["id"] = "";
      filters[by]!["name"] = "";
    }
    update();
  }

  void _scrollListener() async {
    if (returnOrderDetailsList.length == limit) {
      limit = (returnOrderDetailsList.length) + 20;
      _screenFocus();
      await getReturnOrderDetails();
    }
  }

  onSelectDropdown(String id, String title, String forWhom) async {
    isLoading = true;
    if (forWhom == "route") {
      filters["route"]!["id"] = id;
      filters["route"]!["name"] = title;
      var selectedList = routeIdList.where((e) => e == filters["route"]!["id"]).toList();
      if (selectedList.isEmpty) {
        routeIdList.add(filters["route"]!["id"]);
      } else {
        routeIdList.remove(filters["route"]!["id"]);
      }
      for (int i = 0; i < vendorRoutesList.length; i++) {
        var data = routeIdList.where((element) => element == vendorRoutesList[i]['_id']);
        if (data.isNotEmpty) {
          vendorRoutesList[i]['selected'] = true;
        } else {
          vendorRoutesList[i]['selected'] = false;
        }
        update();
      }
    }
    isLoading = false;
    update();
  }

  onSelected() async {
    await getReturnOrderDetails();
    update();
  }

  onRefresh() async {
    _screenFocus();
    await getReturnOrderDetails();
    update();
  }

  onFilterButtonTapped() {
    isFilter = !isFilter;
    isRoutesON = false;
    _screenFocus();
    routeIdList.clear();
    update();
  }

  onRoutesModule() async {
    _screenFocus();
    isRoutesON = !isRoutesON;
    if (isRoutesON) {
      for (int i = 0; i < vendorRoutesList.length; i++) {
        if (vendorRoutesList[i]["selected"] == true) {
          vendorRoutesList[i]['selected'] = false;
        }
        update();
      }
    }
    await _vendorRoutes();
    update();
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onSearchOrders() async {
    txtSearchFocus.unfocus();
    if (txtSearch.text != "") {
      await getReturnOrderDetails();
    }
    update();
  }

  _screenFocus() {
    txtSearch.clear();
    txtSearchFocus.unfocus();
    startDateVendor = "";
    endDateVendor = "";
    routeIdList.clear();
    _onReset("route");
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
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
        DateTime.now(),
      ],
      onValueChanged: (values) async {
        selectedDate = values;
        isLoading = true;
        update();
        startDateVendor =
            '${selectedDate[0]!.year}-${selectedDate[0]!.month.toString().padLeft(2, '0')}-${selectedDate[0]!.day.toString().padLeft(2, '0')}';
        endDateVendor =
            '${selectedDate[1]!.year}-${selectedDate[1]!.month.toString().padLeft(2, '0')}-${selectedDate[1]!.day.toString().padLeft(2, '0')}';
        await getReturnOrderDetails();
        isLoading = false;
        update();
      },
      onCancelTapped: () {
        Get.back();
      },
    );
  }

  _vendorRoutes() async {
    try {
      isLoading = true;
      update();
      var body = {};
      var resData = await apis.call(
        apiMethods.vendorRoutes,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        vendorRoutesList = resData.data;
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  getReturnOrderDetails() async {
    try {
      isLoading = true;
      update();
      var request = {
        "fromDate": startDateVendor,
        "toDate": endDateVendor,
        "search": txtSearch.text,
        "routeId": routeIdList,
        "limit": limit,
        "page": 1,
      };
      var response = await apis.call(apiMethods.getReturnOrderDetails, request, ApiType.post);
      if (response.isSuccess == true) {
        returnOrderDetailsList = response.data["docs"];
        isRoutesON = false;
        update();
      } else {
        warningDialog(
          contentText: response.message.toString(),
          onPressed: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }
}
