// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/home_controller.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/core/widgets/common/menu_card.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) => Container(
        width: Get.width * 0.85,
        color: Colors.white,
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
              currentAccountPicture: GestureDetector(
                onTap: () => homeController.onProfileClick(),
                child: Image.asset(
                  imageAssets.avatar,
                  fit: BoxFit.fill,
                ),
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
                  ExpansionTile(
                    title: const Text("Addresses"),
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        FontAwesomeIcons.addressCard,
                        size: 20,
                      ),
                    ),
                    children: [
                      MenuCard(
                        title: "Global directory",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onAddressesClick(),
                      ),
                      MenuCard(
                        title: "Saved Addresses",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onSaveAddressesClick(),
                      ),
                      MenuCard(
                        title: "Request Addresses",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onRequestAddressesClick(),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text("Vendor orders"),
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        FontAwesomeIcons.box,
                        size: 20,
                      ),
                    ),
                    children: [
                      MenuCard(
                        title: "Create order",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onCreateOrderClick(),
                      ),
                      MenuCard(
                        title: "Create global order",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onCreateGlobalOrderClick(),
                      ),
                      MenuCard(
                        title: "Draft Orders",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onDraftOrdersClick(),
                      ),
                      MenuCard(
                        icon: Icons.circle,
                        title: "Orders view",
                        iconSize: 8.0,
                        onPress: () => homeController.onOrdersClick(),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text("Settlement"),
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        FontAwesomeIcons.wrench,
                        size: 20,
                      ),
                    ),
                    children: [
                      MenuCard(
                        title: "Bill copy settlement",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onBillCopySettementClick(),
                      ),
                      MenuCard(
                        title: "Cash settlement",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onCashSettementClick(),
                      ),
                      MenuCard(
                        title: "Return settlement",
                        icon: Icons.circle,
                        iconSize: 8.0,
                        onPress: () => homeController.onReturnSettementClick(),
                      ),
                    ],
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.solidMessage,
                    title: "Chat",
                    onPress: () => homeController.onChatClick(),
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
    );
  }
}
