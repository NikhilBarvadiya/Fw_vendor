import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  String selectedFilter = "Today";
  String bannersNote = "";
  bool isLoading = false;
  dynamic vendorRevenue;
  dynamic vendorgetPKGDetails;

  @override
  void onInit() {
    _vendorGetRevenue("today");
    _vendorgetPKGDetails("today");
    _vendorGetBanner();
    super.onInit();
  }

  List filters = [
    {
      "icon": Icons.today,
      "label": "today",
      "isActive": true,
    },
    {
      "icon": Icons.calendar_view_week,
      "label": "week",
      "isActive": false,
    },
    {
      "icon": Icons.calendar_view_month,
      "label": "month",
      "isActive": false,
    },
  ];

  onChange(int i) {
    isLoading = true;
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        selectedFilter = filters[a]["label"];
      } else {
        filters[a]["isActive"] = false;
      }
    }
    _onVendorGetRevenue(i);
    isLoading = false;
    update();
  }

  _onVendorGetRevenue(i) async {
    _vendorGetRevenue(filters[i]["label"]);
    _vendorgetPKGDetails(filters[i]["label"]);
    update();
  }

  _vendorGetRevenue(type) async {
    try {
      var resData = await apis.call(
        apiMethods.vendorGetRevenue,
        {
          "type": type,
        },
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        vendorRevenue = resData.data;
        update();
      }
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
  }

  _vendorGetBanner() async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.vendorGetBanner,
        {},
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        bannersNote = resData.data[0]["description"];
        update();
      }
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _vendorgetPKGDetails(type) async {
    try {
      var resData = await apis.call(
        apiMethods.vendorgetPKGDetails,
        {
          "type": type,
        },
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        vendorgetPKGDetails = resData.data[0];
        update();
      }
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  onOrdersClick(data) {
    Get.toNamed(AppRoutes.orders, arguments: data);
    update();
  }

  onDraftOrdersClick() {
    Get.toNamed(AppRoutes.draftOrdersScreen);
    update();
  }

  onComplaintClick(){
    Get.toNamed(AppRoutes.complaintScreen);
    update();
  }

}
