import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  int limit = 15;
  bool isLoading = false;
  bool isSearch = true;
  bool isAdd = false;
  bool isRecorded = false;
  bool isAreaON = false;
  String audioPath = "";
  String selectedTab = "Open";
  List tabs = ["Open", "Resolved", "Processing"];
  String startDateVendor = "";
  String endDateVendor = "";
  List getOrderTicketList = [];
  List orderDetailsOrderTicketList = [];
  List vendorAreaList = [];

  @override
  void onInit() async {
    getOrderTicket();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onReady() async {
    update();
    super.onReady();
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

  void _scrollListener() async {
    if (getOrderTicketList.length == limit) {
      limit = (getOrderTicketList.length) + 20;
      _screenFocus();
      await getOrderTicket();
    }
  }

  willPopScope() {
    Get.offNamedUntil(AppRoutes.home, (route) => false);
  }

  onTabChange(tab) async {
    isLoading = true;
    update();
    _screenFocus();
    selectedTab = tab;
    await getOrderTicket();
    isLoading = false;
    update();
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  onAddButtonTapped() {
    _screenFocus();
    _onReset("area");
    orderDetailsOrderTicketList.clear();
    isAdd = !isAdd;
    update();
  }

  onAreaModule() async {
    _onReset("area");
    isAreaON = !isAreaON;
    if (isAreaON) {
      orderDetailsOrderTicketList.clear();
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
      await getOrderDetailsOrderTicket();
    }
    isLoading = false;
    update();
  }

  onSearchOrders() async {
    isLoading = true;
    txtSearchFocus.unfocus();
    update();
    if (txtSearch.text != "") {
      if (!isAdd) {
        await getOrderTicket();
      } else {
        await getOrderDetailsOrderTicket();
      }
    }
    isLoading = false;
    update();
  }

  clearRecording() {
    isRecorded = false;
    audioPath = "";
    update();
  }

  _screenFocus() {
    txtSearch.clear();
    txtSearchFocus.unfocus();
    startDateVendor = "";
    endDateVendor = "";
    isAreaON = false;
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
        await getOrderTicket();
        isLoading = false;
        update();
      },
      onCancelTapped: () {
        Get.back();
      },
    );
  }

  resolvedOrders(location) {
    var arguments = {
      "location": location,
    };
    Get.toNamed(AppRoutes.ticketsScreen, arguments: arguments);
  }

  // ApiCalling.......

  Future getOrderTicket() async {
    try {
      var status = selectedTab == "Open"
          ? "open"
          : selectedTab == "Resolved"
              ? "resolved"
              : selectedTab == "Processing"
                  ? "processing"
                  : "open";
      var request = {
        "fromDate": startDateVendor,
        "toDate": endDateVendor,
        "search": txtSearch.text,
        "limit": limit,
        "page": 1,
        "status": status,
      };
      var response = await apis.call(apiMethods.getOrderTicket, request, ApiType.post);
      if (response.isSuccess == true) {
        getOrderTicketList = response.data["docs"];
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
  }

  onTicketsView(arguments) async {
    try {
      isLoading = true;
      update();
      var request = {
        "ticketId": arguments["_id"],
      };
      var response = await apis.call(apiMethods.getActivityOrderTicket, request, ApiType.post);
      if (response.isSuccess == true) {
        var json = {
          "view": response.data,
          "orderDetails": arguments,
        };
        Get.toNamed(AppRoutes.complaintViewScreen, arguments: json);
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

  getOrderDetailsOrderTicket() async {
    try {
      isLoading = true;
      update();
      var request = {
        "search": txtSearch.text,
        "fromDate": startDateVendor,
        "toDate": endDateVendor,
        "areaId": filters["area"]!["id"] != "" ? filters["area"]!["id"] : null,
      };
      var response = await apis.call(apiMethods.getOrderDetailsOrderTicket, request, ApiType.post);
      if (response.isSuccess == true) {
        orderDetailsOrderTicketList = response.data;
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
}
