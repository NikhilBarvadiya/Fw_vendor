import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class OrdersCreateController extends GetxController {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtAdress = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtBillNo = TextEditingController();
  TextEditingController txtLoosePkg = TextEditingController();
  TextEditingController txtBoxPkg = TextEditingController();
  TextEditingController txtNotes = TextEditingController();
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtBillAmount = TextEditingController();
  TextEditingController txtLatitueLongitudeController = TextEditingController();
  dynamic latitude;
  dynamic longitude;
  bool isLoading = false;
  List vendorRoutesList = [];
  String routesSelected = "";
  String routesSelectedId = "";
  @override
  void onInit() {
    _vendorRoutes();
    super.onInit();
  }

  willPopScope() {
    Get.offNamed(AppRoutes.home);
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

  onRoutesSelected(String id, String name) {
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

  void onTapLocation() async {
    isLoading = true;
    update();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(
      (value) async {
        isLoading = false;
        latitude = double.parse(value.latitude.toString());
        longitude = double.parse(value.longitude.toString());
        txtLatitueLongitudeController.text = "$latitude\t-\t$longitude";
        update();
      },
    );
  }
}
