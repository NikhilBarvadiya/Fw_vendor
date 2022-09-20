import 'package:flutter/material.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_textfield.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/employe_view/controller/employe_login_controller.dart';
import 'package:get/get.dart';
class EmployeLoginScreen extends StatefulWidget {
  const EmployeLoginScreen({Key? key}) : super(key: key);
  @override
  State<EmployeLoginScreen> createState() => _EmployeLoginScreenState();
}
class _EmployeLoginScreenState extends State<EmployeLoginScreen> {
  EmployeLoginController controller = Get.put(EmployeLoginController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeLoginController>(
      builder: (_) => WillPopScope(
        onWillPop: () async => true,
        child: LoadingMode(
          isLoading: controller.isLoading,
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
                        _loginMobileNumber(),
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
      ),
    );
  }

  _uiTxtView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Employe Panel",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: appScreenUtil.fontSize(20),
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "Please login to start your employe session.",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: appScreenUtil.fontSize(12),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 25, vertical: 10);
  }

  _loginMobileNumber() {
    return customTextField(
      name: "Mobile number",
      maxLength: 10,
      keyboardType: TextInputType.number,
      controller: controller.txtMobileNumber,
      focusNode: controller.focusMobileNumber,
    );
  }

  _loginView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: MaterialButton(
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
        ),
        color: controller.isLoading ? Theme.of(context).primaryColor.withOpacity(.5) : Theme.of(context).primaryColor,
        onPressed: () => controller.onLogin(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: appScreenUtil.size(5),
              ),
              const Icon(Icons.arrow_forward_sharp, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

}
