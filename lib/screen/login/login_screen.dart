// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/login_controller.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_textField.dart';
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
        onWillPop: () async {
          return loginController.isSlider;
        },
        child: Scaffold(
          body: Container(
            height: Get.height,
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
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 25,
                  ),
                  child: Image.asset(
                    imageAssets.logo,
                    width: appScreenUtil.size(100),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: appScreenUtil.size(100)),
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            color: AppController().appTheme.bgGray,
                            fontSize: appScreenUtil.fontSize(30),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: appScreenUtil.size(25)),
                        commonTextField(
                          labelText: "Email",
                          hintText: "Enter your email id",
                          controller: loginController.txtEmailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: appScreenUtil.size(25)),
                        commonTextField(
                          labelText: "Password",
                          hintText: "Enter your password",
                          controller: loginController.txtPasswordController,
                        ),
                        SizedBox(height: appScreenUtil.size(15)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () => loginController.onRemember(),
                              child: Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                    color: AppController().appTheme.bgGray,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  loginController.isRemember ? Icons.check : null,
                                  color: AppController().appTheme.bgGray,
                                  size: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Remember",
                              style: AppCss.h3.copyWith(
                                color: AppController().appTheme.bgGray,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: appScreenUtil.size(40)),
                        commonButton(
                          onTap: () => loginController.onLoginButton(),
                          text: "Log in",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
