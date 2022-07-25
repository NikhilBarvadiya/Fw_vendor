// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/screen/Addresses/global_directory_screen.dart';
import 'package:fw_vendor/screen/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  dynamic loginData;
  bool isSlider = false;
  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  getUserData() async {
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
    {
      "pageName": "Orders",
      "icon": FontAwesomeIcons.box,
      "screen": "",
    },
  ];

  onSwitchScreen(int i) {
    selectedIndex = i;
    Get.back();
    update();
  }

  onNotification() {}

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













