import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class EmployeHomeController extends GetxController with GetSingleTickerProviderStateMixin {
  dynamic employeUserData;
  bool isLoading = false;
  TabController? tabController;
  String type = "all";

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    employeUserData = getStorage(Session.employeUserData);
    _getUserData();
  }

  List draftList = [];
  List myDraftList = [];

  // Tap Click......
  onTapClick(selectedIndex) async {
    type = selectedIndex == 1 ? "my" : " all";
    draftOrders(type);
    update();
  }

  // Login user details....
  _getUserData() async {
    employeUserData = await getStorage(Session.employeUserData);
    await draftOrders("all");
    update();
  }

  // Logout button......
  onLogout(context) async {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          elevation: 2,
          title: const Text("Are you sure?"),
          content: const Text("Do you really want to logout?"),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                clearStorage();
                Get.offNamedUntil(AppRoutes.login, (route) => false);
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  // Routes......
  onScanner() {
    Get.toNamed(AppRoutes.scanner);
    update();
  }

  // Apis.....
  draftOrders(type) async {
    try {
      isLoading = true;
      update();
      var request = {"skip": 0, "limit": 1000, "vendorId": employeUserData["vendorId"]["_id"], "type": type, "search": ""};
      var resData = await apis.call(apiMethods.getDraftOrders, request, ApiType.post);
      if (resData.isSuccess == true && resData.data != 0) {
        if (type == "all") {
          draftList = resData.data;
        } else {
          myDraftList = resData.data;
        }
      }
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }
}
