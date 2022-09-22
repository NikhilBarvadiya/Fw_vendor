// ignore_for_file: deprecated_member_use
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fw_vendor/view/vendor_view/screen/home/drawer.dart';
import 'package:fw_vendor/view/vendor_view/controller/common_controller.dart';
import 'package:fw_vendor/view/vendor_view/controller/home_controller.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/login_controller.dart';
import 'package:fw_vendor/view/vendor_view/screen/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());
  CommonController commonController = Get.find();

  @override
  Widget build(BuildContext context) {
    commonController.statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return GetBuilder<HomeController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return homeController.isSlider;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: true,
            foregroundColor: Colors.white,
            title: Text(
              homeController.pages[homeController.selectedIndex]["pageName"].toString(),
              style: const TextStyle(fontSize: 20),
              textScaleFactor: 1,
              textAlign: TextAlign.center,
            ),
            actions: [
              FlutterSwitch(
                width: 80.0,
                height: 40.0,
                toggleSize: 30.0,
                value: homeController.isStatus,
                borderRadius: 30.0,
                padding: 5.0,
                valueFontSize: 14.0,
                showOnOff: true,
                activeToggleColor: Colors.white,
                inactiveToggleColor: Colors.white,
                activeSwitchBorder: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1.0),
                inactiveSwitchBorder: Border.all(color: Theme.of(context).canvasColor, width: 1.0),
                activeColor: Colors.green,
                inactiveColor: Colors.red,
                activeIcon: const Icon(Icons.check, color: Colors.green),
                inactiveIcon: const Icon(Icons.close, color: Colors.red),
                activeText: 'On'.tr,
                inactiveText: 'Off'.tr,
                onToggle: (val) {
                  homeController.isStatus = val;
                  homeController.changeShopOpenStatus();
                },
              ).paddingOnly(right: 5),
            ],
          ),
          body: DashBoardScreen(),
          drawer: const CustomDrawer(),
        ),
      ),
    );
  }
}
