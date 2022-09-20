import 'package:flutter/material.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/type_controller.dart';
import 'package:get/get.dart';

class TypeScreen extends StatefulWidget {
  const TypeScreen({Key? key}) : super(key: key);

  @override
  State<TypeScreen> createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
  TypeController controller = Get.put(TypeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TypeController>(
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SizedBox(
            height: Get.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        imageAssets.logo,
                        fit: BoxFit.scaleDown,
                        scale: 8,
                      ),
                      _uiTxtView(),
                      const SizedBox(height: 5),
                      SizedBox(height: appScreenUtil.screenHeight(MediaQuery.of(context).size.height) * 0.02),
                      _loginView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _uiTxtView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Login Type",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: appScreenUtil.fontSize(20),
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "Please login to start your session.",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: appScreenUtil.fontSize(12),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 25, vertical: 10);
  }

  _loginView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              color: Theme.of(context).primaryColor,
              onPressed: () => controller.employeLogin(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Employe",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: MaterialButton(
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              color: Theme.of(context).primaryColor,
              onPressed: () => controller.vendorLogin(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Vendor",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
