import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class RequestAddressEditController extends GetxController {
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtLatLng = TextEditingController();
  TextEditingController txtPlusCode = TextEditingController();
  TextEditingController txtAdress = TextEditingController();
  dynamic getAddress;
  String routesSelected = "";
  String routesSelectedId = "";
  bool isLoading = false;
  List vendorRoutesList = [];

  @override
  void onInit() {
    getAddress = Get.arguments;
    _setAddressData();
    super.onInit();
  }

  _setAddressData() async {
    await _vendorRoutes();
    dynamic data = vendorRoutesList.where((element) => element["_id"] == getAddress["routeId"]).toList();
    routesSelected = data[0]["name"];
    txtName.text = getAddress["addressName"];
    txtMobile.text = getAddress["mobile"];
    txtLatLng.text = getAddress["latLong"];
    txtPlusCode.text = getAddress["plusCode"];
    txtAdress.text = getAddress["address"];
    update();
  }

  onClear() {
    routesSelected = "";
    txtName.text = "";
    txtMobile.text = "";
    txtLatLng.text = "";
    txtPlusCode.text = "";
    txtAdress.text = "";
    update();
  }

  onSubmit(context) async {
    await _vendorSetAddressRequest();
    stylishDialog(
      context: context,
      alertType: StylishDialogType.SUCCESS,
      titleText: 'Request Address',
      contentText: "Request Updated Successfully.",
      confirmButton: Colors.green,
      onPressed: () {
        Get.back();
        update();
        Get.offNamedUntil(AppRoutes.requestAddressScreen, (Route<dynamic> route) => false);
        },
    );
    update();
  }

  _vendorRoutes() async {
    try {
      isLoading = true;
      update();
      var body = {};
      var resData = await apis.call(
        apiMethods.vendorRoutes,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        vendorRoutesList = resData.data;
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  selectedRoutes(String id, String name) {
    routesSelected = "";
    routesSelectedId = "";
    routesSelected = name;
    routesSelectedId = id;
    if (routesSelectedId != "") {
      Get.back();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      Get.back();
    }
    update();
  }

  _vendorSetAddressRequest() async {
    try {
      isLoading = true;
      update();
      var body = {
        "address": txtAdress.text,
        "addressName": txtName.text,
        "id": getAddress["_id"],
        "latLong": txtLatLng.text,
        "mobile": txtMobile.text,
        "plusCode": txtPlusCode.text,
        "routeId": routesSelectedId != "" ? routesSelectedId : getAddress["routeId"],
      };
      var resData = await apis.call(
        apiMethods.vendorSetAddressRequest,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {}
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }
}
