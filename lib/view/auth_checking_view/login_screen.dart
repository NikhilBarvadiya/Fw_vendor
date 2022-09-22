// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_textfield.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: LoadingMode(
          isLoading: loginController.isLoading,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: loginController.isEmploye,
                                  onChanged: (value) => loginController.employeLogin(value),
                                ),
                                Text(
                                  "Employee",
                                  style: AppCss.h1,
                                ),
                              ],
                            ),
                            SizedBox(width: appScreenUtil.screenHeight(MediaQuery.of(context).size.height) * 0.02),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: loginController.isVendor,
                                  onChanged: (value) => loginController.vendorLogin(value),
                                ),
                                Text(
                                  "Vendor",
                                  style: AppCss.h1,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: appScreenUtil.screenHeight(MediaQuery.of(context).size.height) * 0.02),
                        if (loginController.isVendor == true) _vendorLogin(),
                        if (loginController.isVendor != true) _employeeLogin(),
                      ],
                    ),
                  )
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
          "${loginController.isVendor != true ? "Employee" : "Vendor"} Panel",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: appScreenUtil.fontSize(20),
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "Please login to start your ${loginController.isVendor != true ? "employee" : "vendor"} session.",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: appScreenUtil.fontSize(12),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 25, vertical: 10);
  }

  _txtCard({name, icon, controller, obscureText, focusNode}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.emailAddress,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Icon(icon),
          ),
          border: InputBorder.none,
          hintText: name,
          counterText: "",
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    ).paddingOnly(left: 20, right: 20);
  }

  _employeeLogin() {
    return Column(
      children: [
        customTextField(
          name: "Mobile number",
          maxLength: 10,
          keyboardType: TextInputType.number,
          controller: loginController.txtMobileNumber,
          focusNode: loginController.focusMobileNumber,
        ),
        SizedBox(height: appScreenUtil.screenHeight(MediaQuery.of(context).size.height) * 0.02),
        _loginView(onPressed: () => loginController.onEmployeeLogin()),
      ],
    );
  }

  _vendorLogin() {
    return Column(
      children: [
        _txtCard(
          name: "Email Id",
          obscureText: false,
          icon: Icons.email,
          controller: loginController.txtEmailController,
          focusNode: loginController.focusEmailNumber,
        ),
        _txtCard(
          name: "Password",
          obscureText: true,
          icon: Icons.lock,
          controller: loginController.txtPasswordController,
          focusNode: loginController.focusPasswordNumber,
        ),
        SizedBox(height: appScreenUtil.screenHeight(MediaQuery.of(context).size.height) * 0.02),
        _loginView(onPressed: () => loginController.onVendorLogin()),
      ],
    );
  }

  _loginView({onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: MaterialButton(
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: loginController.isLoading ? Theme.of(context).primaryColor.withOpacity(.5) : Theme.of(context).primaryColor,
        onPressed: onPressed,
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
