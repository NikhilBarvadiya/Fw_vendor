import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_notes.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class DraftOrdersController extends GetxController {
  TextEditingController txtNotes = TextEditingController();
  TextEditingController txtAddressName = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtLoosePkg = TextEditingController();
  TextEditingController txtBoxPkg = TextEditingController();
  TextEditingController txtBillNo = TextEditingController();
  TextEditingController txtBillAmount = TextEditingController();
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  bool isSearch = true;
  bool isLoading = false;
  bool isFilter = false;
  List getDraftOrderList = [];
  List selectedOrderList = [];
  String startDateVendor = "";
  String endDateVendor = "";
  dynamic editData;

  List dateFilter = [
    {
      "label": "All",
      "icon": Icons.all_inbox,
      "isActive": true,
    },
    {
      "label": "Today",
      "icon": Icons.today,
      "isActive": false,
    },
    {
      "label": "Yesterday",
      "icon": Icons.view_day,
      "isActive": false,
    },
    {
      "label": "Custom",
      "icon": Icons.date_range,
      "isActive": false,
    },
  ];

  var filters = {
    "area": {"id": "", "title": ""},
    "route": {"id": "", "title": ""}
  };

  _onReset(String by) {
    if (by == "all") {
      filters = {
        "area": {"id": "", "title": ""},
        "route": {"id": "", "title": ""}
      };
    } else {
      filters[by]!["id"] = "";
      filters[by]!["title"] = "";
    }
    update();
  }

  @override
  void onInit() {
    _getVendorDraftOrder();
    _autoSelector();
    super.onInit();
  }

  willPopScope() {
    Get.offNamedUntil(AppRoutes.home, (route) => false);
  }

  _screenFocus() {
    txtSearch.clear();
    txtSearchFocus.unfocus();
  }

  onChange(int i) async {
    for (int a = 0; a < dateFilter.length; a++) {
      if (a == i) {
        dateFilter[a]["isActive"] = true;
        txtSearchFocus.unfocus();
      } else {
        dateFilter[a]["isActive"] = false;
      }
    }
    if (dateFilter[i]["label"] == "Custom") {
      customDate();
    } else {
      await onSearchOrders();
    }
    update();
  }

  onSelectDropdown(String id, String title, String forWhom) async {
    isLoading = true;
    if (forWhom == "area") {
      filters["area"]!["id"] = id;
      filters["area"]!["title"] = title;
      _onReset("route");
      // await _getRoutes();
    } else if (forWhom == "route") {
      filters["route"]!["id"] = id;
      filters["route"]!["title"] = title;
    }
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

  onFilterButtonTapped() {
    isFilter = !isFilter;
    update();
  }

  onSearchOrders() async {
    _screenFocus();
    await _getVendorDraftOrder();
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
        // await _getVendorDraftOrder();
        isLoading = false;
        update();
      },
      onCancelTapped: () {
        Get.back();
      },
    );
  }

  _getVendorDraftOrder() async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.getVendorDraftOrder,
        {},
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        getDraftOrderList = resData.data;
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _updateVendorDraftOrder(item) async {
    try {
      isLoading = true;
      update();
      var data = {
        "addressId": {
          "address": txtAddress.text != "" ? txtAddress.text : item["addressId"]["address"].toString(),
          "businessCategoryId": item["addressId"]["businessCategoryId"].toString(),
          "createdAt": item["addressId"]["createdAt"].toString(),
          "flatFloorBuilding": item["addressId"]["flatFloorBuilding"].toString(),
          "isDeleted": item["addressId"]["isDeleted"].toString(),
          "lat": item["addressId"]["lat"].toString(),
          "lng": item["addressId"]["lng"].toString(),
          "mobile": item["addressId"]["mobile"].toString(),
          "name": txtAddressName.text != "" ? txtAddressName.text : item["addressId"]["name"].toString(),
          "person": item["addressId"]["person"].toString(),
          "routeId": item["addressId"]["routeId"]["_id"].toString(),
          "shortNo": item["addressId"]["shortNo"].toString(),
          "updatedAt": item["addressId"]["updatedAt"].toString(),
          "_id": item["addressId"]["_id"],
        },
        "amount": txtBillAmount.text != "" ? txtBillAmount.text : item["amount"].toString(),
        "anyNote": txtNotes.text != "" ? txtNotes.text.toString() : "",
        "billNo": txtBillNo.text != "" ? txtBillNo.text : item["billNo"].toString(),
        "boxes": item["boxes"].toString(),
        "cash": txtAmount.text != "" ? txtAmount.text : item["cash"].toString(),
        "createdAt": item["cash"].toString(),
        "isSelected": item["isSelected"].toString(),
        "nOfBoxes": txtBoxPkg.text != "" ? txtBoxPkg.text : item["nOfBoxes"].toString(),
        "nOfPackages": txtLoosePkg.text != "" ? txtLoosePkg.text : item["nOfPackages"].toString(),
        "orderType": item["orderType"].toString(),
        "type": item["type"].toString(),
        "updatedAt": item["updatedAt"].toString(),
        "vendorId": item["vendorId"].toString(),
        "_id": item["_id"],
      };
      var resData = await apis.call(
        apiMethods.updateVendorDraftOrder,
        {
          "data": data,
        },
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        var index = getDraftOrderList.indexOf(item);
        getDraftOrderList.remove(item);
        getDraftOrderList.insert(index, data);
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

  _deleteVendorDraftOrder(item) async {
    try {
      isLoading = true;
      update();
      var data = {
        "draftIds": [item],
      };
      var resData = await apis.call(
        apiMethods.deleteVendorDraftOrder,
        data,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {}
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onNotes(item, context) async {
    stylishDialog(
      context: context,
      alertType: StylishDialogType.NORMAL,
      titleText: "Message",
      contentText: "Do you Delete this orders?",
      txtCancelButton: "Reset",
      confirmButton: Colors.green,
      cancelButtonColor: Colors.redAccent,
      addView: customNotesText(
        controller: txtNotes,
        hintText: "Type your message here......",
        height: 100,
      ),
      cancelButton: true,
      onCancel: () {
        txtNotes.clear();
        update();
        Get.back();
      },
      onPressed: () async {
        Get.back();
        await _updateVendorDraftOrder(item);
      },
    );
  }

  onLocationUpdate(item, context) async {
    stylishDialog(
      context: context,
      alertType: StylishDialogType.INFO,
      titleText: "Update",
      contentText: "Do you update this orders?",
      txtCancelButton: "Reset",
      confirmButton: Colors.green,
      cancelButtonColor: Colors.redAccent,
      cancelButton: true,
      onCancel: () {
        Get.back();
      },
      onPressed: () async {
        selectedOrderList.clear();
        update();
        Get.back();
        await _updateVendorDraftOrder(item);
        Get.offNamed(AppRoutes.draftOrdersScreen);
      },
    );
  }

  onEdit(item) {
    editData = item;
    txtAddressName.text = item["addressId"]["name"].toString();
    txtAddress.text = item["addressId"]["address"].toString();
    txtBillNo.text = item["billNo"].toString();
    txtBillAmount.text = item["amount"].toString();
    txtAmount.text = item["cash"].toString();
    txtLoosePkg.text = item["nOfPackages"].toString();
    txtBoxPkg.text = item["nOfBoxes"].toString();
    txtNotes.text = item["anyNote"].toString();
    update();
    Get.toNamed(AppRoutes.editSelectedLocationScreen);
  }

  onDeleteOrders(item, context) {
    if (item != null) {
      stylishDialog(
        context: context,
        alertType: StylishDialogType.ERROR,
        titleText: "Delete",
        contentText: "Do you Delete this orders?",
        confirmButton: Colors.green,
        cancelButtonColor: Colors.redAccent,
        cancelButton: true,
        onCancel: () {
          Get.back();
        },
        onPressed: () async {
          Get.back();
          await _deleteVendorDraftOrder(item["_id"]);
        },
      );
    }
  }

  addToSelectedList(item, context) {
    if (item != null) {
      var index = selectedOrderList.indexOf(item);
      if (index == -1) {
        selectedOrderList.add(item);
        update();
      } else {
        selectedOrderList.remove(item);
        update();
      }
      _autoSelector();
    }
  }

  _autoSelector() {
    for (int i = 0; i < getDraftOrderList.length; i++) {
      var data = selectedOrderList.where((element) => element['_id'] == getDraftOrderList[i]['_id']);
      if (data.isNotEmpty) {
        getDraftOrderList[i]['selected'] = true;
      } else {
        getDraftOrderList[i]['selected'] = false;
      }
      update();
    }
  }

  onProceed(arguments) {
    if (selectedOrderList.isNotEmpty) {
      Get.offNamed(AppRoutes.placeOrderScreen, arguments: arguments);
      update();
    }
  }
}
