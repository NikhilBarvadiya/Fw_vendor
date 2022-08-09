// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/controller/home_controller.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ProfileController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  dynamic profileData;
  bool isEdit = false;
  bool isLoading = false;
  List shopAvailability = [];
  TextEditingController txtShopName = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmailId = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtArea = TextEditingController();
  TextEditingController txtPincode = TextEditingController();
  TextEditingController txtLat = TextEditingController();
  TextEditingController txtLong = TextEditingController();
  TextEditingController txtPreparationTime = TextEditingController();
  TextEditingController txtGst = TextEditingController();
  TextEditingController txtGSTCertificate = TextEditingController();
  TextEditingController txtCurrentPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  @override
  void onInit() {
    profileData = Get.arguments;
    shopAvailabilityData();
    super.onInit();
  }

  willPopScope() {
    if (isEdit == true) {
      isEdit = false;
      update();
    } else {
      Get.offNamed(AppRoutes.home);
    }
  }

  onEdit() {
    try {
      isLoading = true;
      isEdit = true;
      txtShopName.text = profileData["name"].toString();
      txtName.text = profileData["ownerName"].toString();
      txtEmailId.text = profileData["emailId"].toString();
      txtAddress.text = profileData["address"]["address_line"].toString();
      txtArea.text = profileData["address"]["area"].toString();
      txtPincode.text = profileData["address"]["pincode"].toString();
      txtLat.text = profileData["address"]["geoLocation"]["lat"].toString();
      txtLong.text = profileData["address"]["geoLocation"]["long"].toString();
      update();
    } catch (e) {
      return e;
    }
    isLoading = false;
    update();
  }

  onSave(context) async {
    try {
      isLoading = true;
      update();
      var data = {};
      var resData = await apis.call(
        apiMethods.vendorUpdateProfile,
        data,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        stylishDialog(
          context: context,
          alertType: StylishDialogType.SUCCESS,
          titleText: 'Update succes',
          contentText: resData.message.toString(),
          confirmButton: Colors.green,
          onPressed: () {
            isEdit = false;
            Get.back();
            update();
          },
        );
      }
      update();
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onCancel(context) {
    stylishDialog(
      context: context,
      alertType: StylishDialogType.ERROR,
      titleText: 'Cancel',
      confirmButton: Colors.redAccent,
      contentText: "Do you cancel edit procces account!",
      onPressed: () {
        isEdit = false;
        txtShopName.clear();
        txtName.clear();
        txtEmailId.clear();
        txtAddress.clear();
        txtArea.clear();
        txtPincode.clear();
        txtLat.clear();
        txtLong.clear();
        update();
        Get.back();
      },
    );
  }

  onPreparationTime(context) async {
    try {
      isLoading = true;
      update();
      var data = {
        "prepTime": txtPreparationTime.text.toString(),
      };
      var resData = await apis.call(
        apiMethods.vendorUpdatePreparationTime,
        data,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        stylishDialog(
          context: context,
          alertType: StylishDialogType.SUCCESS,
          titleText: 'Update succes',
          confirmButton: Colors.green,
          contentText: resData.message.toString(),
          onPressed: () {
            Get.back();
          },
        );
      }
      update();
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  shopAvailabilityData() {
    if (profileData["timings"] != null && profileData["timings"] != "") {
      for (int i = 0; i < profileData["timings"].length; i++) {
        shopAvailability.add(
          {
            "day": profileData["timings"][i]["day"],
            "timings": profileData["timings"][i]["timings"],
          },
        );
      }
    }
  }

  updateTimings(data, timings, day, context) {
    if (data != null) {
      var index = shopAvailability.indexOf(data);
      if (index != -1) {
        shopAvailability[index]["timings"] = timings;
        update();
      }
    } else {
      int index = shopAvailability.indexWhere((element) => element["day"] == day);
      if (index != -1) {
        shopAvailability[index]["timings"] = timings;
      } else {
        shopAvailability.add(
          {
            "day": day,
            "timings": timings,
          },
        );
      }
      update();
    }
    shopAvailabilityEvent(context);
  }

  shopAvailabilityEvent(context) async {
    try {
      isLoading = true;
      update();
      var data = {
        "shopTimings": shopAvailability,
      };
      var resData = await apis.call(
        apiMethods.vendorUpdateShopTimings,
        data,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        homeController.vendorWhoAmI();
        stylishDialog(
          context: context,
          alertType: StylishDialogType.SUCCESS,
          titleText: 'Update succes',
          contentText: resData.message.toString(),
          confirmButton: Colors.green,
          onPressed: () {
            Get.back();
          },
        );
      }
      update();
    } catch (e) {
      snackBar(e.toString(), Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onGst(context) {
    stylishDialog(
      context: context,
      alertType: StylishDialogType.SUCCESS,
      titleText: 'Update succes',
      contentText: "GST number save",
      confirmButton: Colors.green,
      onPressed: () {
        isEdit = false;
        update();
        Get.back();
      },
    );
  }

  onChangePassword() async {
    if (txtNewPassword.text == txtConfirmPassword.text) {
      try {
        isLoading = true;
        update();
        var data = {
          "currentPassword": txtCurrentPassword.text.toString(),
          "newPassword": txtNewPassword.text.toString(),
        };
        var resData = await apis.call(
          apiMethods.vendorUpdatePassword,
          data,
          ApiType.post,
        );
        if (resData.isSuccess == true && resData.data != 0) {
          isLoading = true;
          await Future.delayed(const Duration(seconds: 3));
          isLoading = false;
          clearStorage();
          Get.offNamed(AppRoutes.login);
          update();
        }
        update();
      } catch (e) {
        snackBar(e.toString(), Colors.red);
        isLoading = false;
        update();
      }
      isLoading = false;
      update();
    } else {
      snackBar("New password & confirm password must be same", Colors.deepOrange);
    }
  }
}
