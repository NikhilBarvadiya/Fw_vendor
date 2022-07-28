// ignore_for_file: deprecated_member_use
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/common_controller.dart';
import 'package:fw_vendor/controller/home_controller.dart';
import 'package:fw_vendor/controller/login_controller.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/core/widgets/common_widgets/menu_card.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
            // backgroundColor: homeController.isStatus ? Theme.of(context).primaryColor : Theme.of(context).splashColor,
            title: Text(
              homeController.pages[homeController.selectedIndex]["pageName"].toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
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
                activeSwitchBorder: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1.0,
                ),
                inactiveSwitchBorder: Border.all(
                  color: Theme.of(context).canvasColor,
                  width: 1.0,
                ),
                activeColor: Colors.green,
                inactiveColor: Colors.red,
                activeIcon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                inactiveIcon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                activeText: 'On'.tr,
                inactiveText: 'Off'.tr,
                onToggle: (val) {
                  homeController.isStatus = val;
                  homeController.changeShopOpenStatus();
                },
              ).paddingOnly(right: 5),
            ],
          ),
          body: homeController.pages[homeController.selectedIndex]["screen"],
          drawer: SizedBox(
            width: Get.width * 0.85,
            child: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppController().appTheme.primary1.withOpacity(.9),
                          AppController().appTheme.primary.withOpacity(.9),
                        ],
                      ),
                    ),
                    currentAccountPicture: Image.asset(
                      imageAssets.avatar,
                      fit: BoxFit.fill,
                    ),
                    accountName: Text(
                      homeController.loginData != null ? homeController.loginData['name'].toString() : 'NA',
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      homeController.loginData != null ? homeController.loginData['emailId'].toString() : 'NA',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0),
                      children: [
                        for (int i = 0; i < homeController.pages.length; i++)
                          MenuCard(
                            title: homeController.pages[i]["pageName"].toString(),
                            icon: homeController.pages[i]["icon"],
                            onPress: () => homeController.onSwitchScreen(i),
                          ),
                        MenuCard(
                          icon: FontAwesomeIcons.box,
                          title: "Orders",
                          onPress: () {
                            //homeController.onOrdersClick()
                          },
                        ),
                        MenuCard(
                          icon: FontAwesomeIcons.rightFromBracket,
                          title: "Log out",
                          onPress: () => homeController.onLogout(context),
                        ),
                        SizedBox(height: appScreenUtil.size(20)),
                        Center(
                          child: Text(
                            "Support".toUpperCase(),
                            style: TextStyle(
                              color: AppController().appTheme.accentTxt,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: appScreenUtil.size(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String link = "tel:6357017016";
                                await launch(link);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width * 0.05),
                            GestureDetector(
                              onTap: () async {
                                String link = "https://wa.me/916357017016";
                                await launch(link);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.whatsapp,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width * 0.05),
                            GestureDetector(
                              onTap: () async {
                                String link = "mailto:contact@fastwhistle.com";
                                await launch(link);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.mail_outline_rounded,
                                    color: Colors.deepOrange[200],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: appScreenUtil.size(10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
