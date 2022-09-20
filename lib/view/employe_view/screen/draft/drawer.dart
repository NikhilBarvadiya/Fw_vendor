import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/widgets/common/menu_card.dart';
import 'package:get/get.dart';

class DrawerView extends StatefulWidget {
  final String? name;
  final String? vendorName;
  final String? mobile;
  final bool? isLoading;
  final void Function()? onPressed;

  const DrawerView({Key? key, this.name, this.mobile, this.onPressed, this.isLoading, this.vendorName}) : super(key: key);

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
              currentAccountPicture: Image.asset(
                imageAssets.avatar,
                fit: BoxFit.fill,
              ),
              accountName: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.name ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.vendorName ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                  ),
                ],
              ),
              accountEmail: Text(
                widget.mobile ?? "",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            MenuCard(
              icon: FontAwesomeIcons.rightFromBracket,
              title: "Logout",
              onPress: widget.onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
