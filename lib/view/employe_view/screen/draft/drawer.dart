import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/widgets/common/menu_card.dart';
import 'package:get/get.dart';

class DrawerView extends StatefulWidget {
  final String? name;
  final String? vendorName;
  final String? appVersion;
  final String? mobile;
  final bool? isLoading;
  final void Function()? onPressed;

  const DrawerView({
    Key? key,
    this.name,
    this.mobile,
    this.onPressed,
    this.isLoading,
    this.appVersion,
    this.vendorName,
  }) : super(key: key);

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.85,
      child: Drawer(
        child: Column(
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
              currentAccountPicture: Image.asset(imageAssets.avatar, fit: BoxFit.fill),
              accountName: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.name ?? "", style: const TextStyle(color: Colors.white)),
                  Text(
                    widget.vendorName ?? "",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ],
              ),
              accountEmail: Text(widget.mobile ?? "", style: const TextStyle(color: Colors.white)),
            ),
            const Spacer(),
            MenuCard(icon: FontAwesomeIcons.rightFromBracket, title: "Logout", onPress: widget.onPressed),
            Divider(indent: 50.0, endIndent: 50.0, color: AppController().appTheme.primary.withOpacity(.4)),
            Center(
              child: Text(
                "V${widget.appVersion ?? ""}",
                style: TextStyle(color: AppController().appTheme.primary1.withOpacity(.4), fontWeight: FontWeight.w500, letterSpacing: 1),
              ),
            ).paddingOnly(bottom: 10),
          ],
        ),
      ),
    );
  }
}
