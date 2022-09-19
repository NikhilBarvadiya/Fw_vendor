// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/view/vendor_view/controller/login_controller.dart';
import 'package:get/get.dart';

class CommonShowProfile extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
  String? vendorName;
  String? ownerName;

  CommonShowProfile({
    Key? key,
    this.vendorName,
    this.ownerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ownerName ?? "",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    vendorName ?? "",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      // await Get.toNamed(routeName.editProfile);
                      // await moreController.userLocalData();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(FontAwesomeIcons.pencilAlt, size: 12, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              "EditProfile".tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
