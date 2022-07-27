// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:fw_vendor/screen/Addresses/global_directory_screen.dart';
import 'package:fw_vendor/screen/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  dynamic loginData;
  int selectedIndex = 0;
  bool isSlider = false;
  bool isLoading = false;
  bool isStatus = false;

  @override
  void onInit() {
    _getUserData();
    vendorWhoAmI();
    super.onInit();
  }

  _getUserData() async {
    loginData = await getStorage(Session.userData);
    update();
  }

  List pages = [
    {
      "pageName": "Dashboard",
      "icon": FontAwesomeIcons.dashboard,
      "screen": DashBoardScreen(),
    },
    {
      "pageName": "Addresses",
      "icon": FontAwesomeIcons.addressCard,
      "screen": GlobalDirectoryScreen(),
    },
    {
      "pageName": "Masters",
      "icon": FontAwesomeIcons.marsAndVenus,
      "screen": "",
    },
  ];

  onSwitchScreen(int i) {
    selectedIndex = i;
    Get.back();
    update();
  }

  onNotification() {}

  changeShopOpenStatus() async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.changeShopOpenStatus,
        {
          "status": false,
        },
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        isStatus = true;
        await vendorWhoAmI();
      } else {
        isStatus = false;
        snackBar(resData.message!, null);
      }
      update();
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
  }

  vendorCheckProfile() async {
    try {
      var resData = await apis.call(
        apiMethods.vendorCheckProfile,
        {},
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {}
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
  }

  vendorWhoAmI() async {
    try {
      isLoading = true;
      update();
      var resData = await apis.call(
        apiMethods.vendorWhoAmI,
        {},
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        isStatus = resData.data["isVendorOpen"];
      }
      update();
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
  }

  onOrdersClick() {
    Get.toNamed(AppRoutes.orders);
    update();
  }

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
                Get.offNamed(AppRoutes.login);
                update();
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
}
