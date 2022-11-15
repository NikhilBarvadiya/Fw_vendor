// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/utilities/index.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_stylish_dialog.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_textfield.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

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
                        Image.asset(imageAssets.logo, fit: BoxFit.scaleDown, scale: 8),
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
                                Text("Employee", style: AppCss.h1),
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
                                Text("Vendor", style: AppCss.h1)
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
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: loginController.isTimer == true
                ? CustomFloatingActionButton(
                    isShowFab: loginController.isBottomSheet,
                    isType: loginController.isVendor,
                  )
                : Container(),
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
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: appScreenUtil.fontSize(20), fontWeight: FontWeight.w800),
        ),
        Text(
          "Please login to start your ${loginController.isVendor != true ? "employee" : "vendor"} session.",
          style: TextStyle(color: Colors.grey[700], fontSize: appScreenUtil.fontSize(12), fontWeight: FontWeight.w400),
        ),
      ],
    ).paddingSymmetric(horizontal: 25, vertical: 10);
  }

  _txtCard({name, icon, controller, obscureText, focusNode}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.emailAddress,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: Padding(padding: const EdgeInsets.only(left: 15), child: Icon(icon)),
          border: InputBorder.none,
          hintText: name,
          counterText: "",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
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
              const Text("Continue", style: TextStyle(fontSize: 18)),
              SizedBox(width: appScreenUtil.size(5)),
              const Icon(Icons.arrow_forward_sharp, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatefulWidget {
  bool isShowFab;
  bool isType;

  CustomFloatingActionButton({Key? key, required this.isShowFab, required this.isType}) : super(key: key);

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  @override
  initState() {
    onHistoryClick();
    super.initState();
  }

  List loginAs = [];
  List employeeLoginAs = [];
  dynamic employeUserData;

  onHistoryClick() async {
    loginAs = await getStorage(Session.loginAs);
    employeeLoginAs = await getStorage(Session.employeeLoginAs);
    employeUserData = await getStorage(Session.employeUserData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isType == true && loginAs.isNotEmpty) || (widget.isType != true && employeeLoginAs.isNotEmpty)
        ? FloatingActionButton(
            elevation: 0,
            onPressed: () {
              if (!widget.isShowFab) {
                showFloatingActionButton(true);
                if (widget.isShowFab) {
                  var bottomSheetController = showBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      decoration:
                          const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)), color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 5.0),
                      ]),
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Login As", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)).paddingOnly(bottom: 10, left: 15),
                          if (widget.isType == true)
                            ...loginAs.map((e) {
                              var index = loginAs.indexOf(e);
                              return ListTile(
                                onTap: () {
                                  LoginController loginController = Get.put(LoginController());
                                  loginController.onLoginAsClick(e);
                                },
                                trailing: IconButton(
                                  onPressed: () {
                                    onRemoveLoginAsClick(index);
                                  },
                                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                ),
                                title: Text(e["emailId"].toString()),
                                subtitle: Row(
                                  children: [
                                    for (int i = 0; i < 5; i++) const Icon(Icons.circle_rounded, size: 10).paddingOnly(right: 1),
                                  ],
                                ),
                              );
                            }),
                          if (widget.isType != true)
                            ...employeeLoginAs.map((e) {
                              var index = employeeLoginAs.indexOf(e);
                              return ListTile(
                                onTap: () {
                                  LoginController loginController = Get.put(LoginController());
                                  loginController.onEmployeeLoginAsClick(e);
                                },
                                trailing: IconButton(
                                  onPressed: () {
                                    onRemoveEmployeeLoginAsClick(index);
                                  },
                                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                ),
                                title: Text(e["mobile"].toString()),
                                subtitle: Text(
                                  employeUserData["name"].toString().capitalizeFirst.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              );
                            }),
                        ],
                      ).paddingOnly(top: 10, left: 10, right: 10),
                    ).paddingSymmetric(vertical: 2),
                  );
                  bottomSheetController.closed.then((value) {
                    showFloatingActionButton(false);
                  });
                }
              }
            },
            backgroundColor: widget.isShowFab == false ? Colors.amber[300] : Colors.white,
            foregroundColor: Colors.black87,
            child: const Icon(Icons.lock),
          )
        : Container();
  }

  void showFloatingActionButton(bool value) {
    setState(() {
      widget.isShowFab = value;
    });
  }

  onRemoveLoginAsClick(index) async {
    List loginAsList = [];
    loginAs = await getStorage(Session.loginAs);
    loginAsList = loginAs;
    for (int i = 0; i < loginAsList.length; i++) {
      if (index == i) {
        loginAsList.removeAt(i);
      }
    }
    await writeStorage(Session.loginAs, loginAsList);
    setState(() {});
    Get.back();
  }

  onRemoveEmployeeLoginAsClick(index) async {
    List employeeLoginAsList = [];
    employeeLoginAs = await getStorage(Session.employeeLoginAs);
    employeeLoginAsList = employeeLoginAs;
    for (int i = 0; i < employeeLoginAsList.length; i++) {
      if (index == i) {
        employeeLoginAsList.removeAt(i);
      }
    }
    await writeStorage(Session.employeeLoginAs, employeeLoginAsList);
    setState(() {});
    Get.back();
  }
}
