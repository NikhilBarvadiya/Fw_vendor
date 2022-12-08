import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class EmployeHomeController extends GetxController with GetSingleTickerProviderStateMixin {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  dynamic employeUserData;
  bool isLoading = false;
  bool isSearch = false;
  TabController? tabController;
  List draftList = [];
  List myDraftList = [];
  List allFilteredList = [];
  List myFilteredList = [];
  String type = "all";

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    employeUserData = getStorage(Session.employeUserData);
    _getUserData();
    txtSearchFocus.unfocus();
  }

  // Tap Click......
  onTapClick(selectedIndex) async {
    isSearch = false;
    txtSearch.text = "";
    txtSearchFocus.unfocus();
    Vibration.vibrate(duration: 10);
    type = selectedIndex == 1 ? "my" : " all";
    await draftOrders(type);
    update();
  }

  onSearchClick() {
    txtSearch.text = "";
    txtSearchFocus.unfocus();
    isSearch = !isSearch;
    update();
  }

  onEditingComplete() {
    isSearch = false;
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
              onPressed: () async {
                var loginAs = await getStorage(Session.loginAs);
                var employeUserData = await getStorage(Session.employeUserData);
                var employeeLoginAs = await getStorage(Session.employeeLoginAs);
                await clearStorage();
                await writeStorage(Session.loginAs, loginAs);
                await writeStorage(Session.employeUserData, employeUserData);
                await writeStorage(Session.employeeLoginAs, employeeLoginAs);
                Get.offNamedUntil(AppRoutes.login, (Route<dynamic> route) => false);
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
    txtSearchFocus.unfocus();
    Get.toNamed(AppRoutes.scanner);
    update();
  }

  // Apis.....
  draftOrders(type) async {
    try {
      txtSearch.text = "";
      isLoading = true;
      update();
      var request = {
        "skip": 0,
        "limit": 1000,
        "vendorId": employeUserData["vendorId"]["_id"],
        "type": type,
        "search": "",
      };
      var resData = await apis.call(apiMethods.getDraftOrders, request, ApiType.post);
      if (resData.isSuccess == true && resData.data != 0) {
        if (type == "all") {
          allFilteredList = resData.data;
          draftList = resData.data;
        } else {
          myFilteredList = resData.data;
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

  void runFilter(String enteredKeyword) {
    if (type == "all") {
      if (enteredKeyword == "") {
        allFilteredList.clear();
        allFilteredList = json.decode(json.encode(draftList));
      } else {
        allFilteredList = draftList
            .where(
              (record) => (record["addressId"]["name"].toString().toLowerCase().contains(enteredKeyword.toLowerCase())),
            )
            .toList();
      }
    } else {
      if (enteredKeyword == "") {
        myFilteredList.clear();
        myFilteredList = json.decode(json.encode(myDraftList));
      } else {
        myFilteredList = myDraftList
            .where(
              (record) => (record["addressId"]["name"].toString().toLowerCase().contains(enteredKeyword.toLowerCase())),
            )
            .toList();
      }
    }
    update();
  }
}
