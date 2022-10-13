import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class OrdersStatisticsController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  int limit = 15;
  bool isLoading = false;
  bool isSearch = true;
  bool isFilter = true;
  bool isRoutesON = false;
  bool isAreaON = false;
  String startDateVendor = "";
  String endDateVendor = "";
  List statisticsOrdersList = [];
  List vendorRoutesList = [];
  List vendorAreaList = [];
  List routeIdList = [];

  @override
  void onInit() async {
    _apiCallingStart();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  _apiCallingStart() async {
    startDateVendor = getFormattedDate2(DateTime.utc(DateTime.now().year, DateTime.now().month, 1).toString());
    endDateVendor = getFormattedDate2(DateTime.now().toString());
    await statisticsOrderDetails();
  }

  willPopScope() {
    Get.offNamedUntil(AppRoutes.home, (route) => false);
  }

  var filters = {
    "route": {"id": "", "name": ""},
    "area": {"id": "", "name": ""},
  };

  var total = {"totalPkg": "", "totalBox": "", "totalLocation": ""};

  _onReset(String by) {
    if (by == "all") {
      filters = {
        "route": {"id": "", "name": ""},
        "area": {"id": "", "name": ""},
      };
    } else {
      filters[by]!["id"] = "";
      filters[by]!["name"] = "";
    }
    update();
  }

  _screenFocus() {
    txtSearch.clear();
    txtSearchFocus.unfocus();
    _onReset("all");
  }

  void _scrollListener() async {
    if (statisticsOrdersList.length == limit) {
      limit = (statisticsOrdersList.length) + 20;
      _screenFocus();
      await statisticsOrderDetails();
    }
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
      await statisticsOrderDetails();
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
        await statisticsOrderDetails();
        isLoading = false;
        update();
      },
      onCancelTapped: () {
        Get.back();
      },
    );
  }

  onFilterButtonTapped() {
    isFilter = !isFilter;
    isRoutesON = false;
    isAreaON = false;
    _screenFocus();
    routeIdList.clear();
    update();
  }

  onSelectDropdown(String id, String title, String forWhom) async {
    isLoading = true;
    _screenFocus();
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
    } else if (forWhom == "area") {
      filters["area"]!["id"] = id;
      filters["area"]!["name"] = title;
      for (int i = 0; i < vendorAreaList.length; i++) {
        if (vendorAreaList[i]['_id'] == filters["area"]!["id"]) {
          vendorAreaList[i]['selected'] = true;
        } else {
          vendorAreaList[i]['selected'] = false;
        }
        update();
      }
      if (filters["area"]!["id"] != null && filters["area"]!["id"] != "") {
        await statisticsOrderDetails();
      }
    }
    isLoading = false;
    update();
  }

  onRoutesModule() async {
    _screenFocus();
    isAreaON = false;
    isRoutesON = !isRoutesON;
    if (isRoutesON) {
      statisticsOrdersList.clear();
      routeIdList.clear();
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

  onSelected() async {
    if(routeIdList.isNotEmpty){
      await statisticsOrderDetails();
    }
    update();
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

  onAreaModule() async {
    isRoutesON = false;
    update();
    _screenFocus();
    isAreaON = !isAreaON;
    if (isAreaON) {
      statisticsOrdersList.clear();
      for (int i = 0; i < vendorAreaList.length; i++) {
        if (vendorAreaList[i]["selected"] == true) {
          vendorAreaList[i]['selected'] = false;
        }
        update();
      }
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
      errorDialog(
        contentText: e.toString(),
        onPressed: () {
          Get.back();
        },
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  statisticsOrderDetails() async {
    try {
      isLoading = true;
      update();
      var request = {
        "fromDate": startDateVendor,
        "toDate": endDateVendor,
        "search": txtSearch.text,
        "routeId": routeIdList,
        "areaId": filters["area"]!["id"] != "" ? filters["area"]!["id"] : null,
        "limit": limit,
        "page": 1,
      };
      var response = await apis.call(apiMethods.statisticsOrderPackagesDetails, request, ApiType.post);
      if (response.isSuccess == true) {
        statisticsOrdersList = response.data["result"]["docs"];
        total["totalPkg"] = response.data["agtResult"]["totalPkg"].toString();
        total["totalBox"] = response.data["agtResult"]["totalBox"].toString();
        total["totalLocation"] = response.data["agtResult"]["totalLocation"].toString();
        txtSearch.clear();
        txtSearchFocus.unfocus();
        isRoutesON = false;
        isAreaON = false;
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
