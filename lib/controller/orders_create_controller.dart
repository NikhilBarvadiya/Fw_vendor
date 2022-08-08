import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/utilities/storage_utils.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

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
  TextEditingController txtLatLng = TextEditingController();
  bool isLoading = false;
  bool isPaymentMode = false;
  List vendorRoutesList = [];
  List customerAddressNameList = [];
  List saveShopOrder = [];
  List createList = [];
  List addresses = [];
  dynamic secondData;
  String routesSelected = "";
  String routesSelectedId = "";
  String nameSelectedId = "";
  String areaId = "";

  @override
  void onInit() {
    _vendorRoutes();
    _getAllCustomerAddressName();
    super.onInit();
  }

  onCLear() {
    txtName.clear();
    txtAdress.clear();
    routesSelected = "";
    txtMobile.clear();
    txtBillNo.clear();
    txtLoosePkg.clear();
    txtBoxPkg.clear();
    txtNotes.clear();
    txtAmount.clear();
    txtBillAmount.clear();
    txtLatLng.clear();
    routesSelectedId = "";
    nameSelectedId = "";
    areaId = "";
    isPaymentMode = false;
    update();
  }

  willPopScope() {
    createList.clear();
    addresses.clear();
    onCLear();
    Get.offNamed(AppRoutes.home);
  }

  willPopScopeCreateOrdersFroms() {
    onCLear();
    update();
    Get.back();
  }

  onAdd() {
    Get.toNamed(AppRoutes.ordersFromScreen);
  }

  onShowAdrresBook() {
    Get.toNamed(AppRoutes.showAdrresBookScreen);
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

  onRoutesSelected(String id, String name, e) {
    routesSelected = "";
    routesSelectedId = "";
    routesSelected = name;
    routesSelectedId = id;
    areaId = e["areaId"]["_id"].toString();
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

  _getAllCustomerAddressName() async {
    try {
      isLoading = true;
      update();
      var body = {};
      var resData = await apis.call(
        apiMethods.getAllCustomerAddressName,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        customerAddressNameList = resData.data;
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onNameSelected(String id, String name) async {
    nameSelectedId = "";
    txtName.text = name;
    nameSelectedId = id;
    if (nameSelectedId != "") {
      Get.back();
      await _getCustomerAddressById();
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

  _getCustomerAddressById() async {
    try {
      isLoading = true;
      update();
      var body = {
        "id": nameSelectedId,
      };
      var resData = await apis.call(
        apiMethods.getCustomerAddressById,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        txtAdress.text = resData.data["address"].toString().capitalizeFirst.toString();
        txtMobile.text = resData.data["mobile"];
        txtLatLng.text = "${resData.data["lat"]}\t-\t${resData.data["lng"]}";
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onCredit() {
    if (txtAmount.text.isNotEmpty) {
      txtBillAmount.text = txtAmount.text;
    } else {
      txtAmount.text = txtBillAmount.text;
    }
    if (txtAmount.text.isNotEmpty && txtBillAmount.text.isNotEmpty) {
      isPaymentMode = true;
    }
    update();
  }

  onCash() {
    if (txtBoxPkg.text.isNotEmpty || txtBillAmount.text.isNotEmpty) {
      txtAmount.text = "";
    }
    isPaymentMode = false;
    update();
  }

  _saveShopOrder(context) async {
    try {
      isLoading = true;
      update();
      var body = createList;
      var resData = await apis.call(
        apiMethods.saveShopOrder,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        await _saveCustomerAddress(context);
        onCLear();
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  _saveCustomerAddress(context) async {
    try {
      isLoading = true;
      update();
      var body = {"addresses": addresses};
      var resData = await apis.call(
        apiMethods.saveCustomerAddress,
        body,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        createList.clear();
        addresses.clear();
        onCLear();
        StylishDialog(
          context: context,
          alertType: StylishDialogType.SUCCESS,
          titleText: 'Update succes',
          contentText: "Shop order placed successfully",
          confirmButton: AnimatedButton(
            height: 30,
            width: Get.width * 0.3,
            color: Colors.green,
            shadowDegree: ShadowDegree.light,
            enabled: true,
            shape: BoxShape.rectangle,
            child: const Text(
              'Ok',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Get.back();
              Get.offNamed(AppRoutes.home);
            },
          ),
        ).show();
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onCreateOrder() async {
    List finalCreateList = [];
    List finalCreateAddressList = [];
    var getData = await getStorage(Session.userData);
    var data = {
      "name": txtName.text.toString(),
      "address": txtAdress.text.toString(),
      "routeId": routesSelectedId,
      "routeName": routesSelected,
      "mobile": txtMobile.text.toString(),
      "billNo": txtBillNo.text.toString(),
      "amount": txtBillAmount.text.toString(),
      "cash": txtAmount.text.toString(),
      "paymentMethod": isPaymentMode != true ? "credit" : "cod",
      "notes": txtNotes.text.toString(),
      "latLong": txtLatLng.text.toString().replaceAll("\t-\t", ","),
      "nOfPackages": txtLoosePkg.text.toString(),
      "nOfBoxes": txtBoxPkg.text.toString(),
      "orderType": getData["businessType"],
      "businessCategoryId": getData["businessCategoryId"]["_id"].toString(),
    };
    secondData = {
      "name": txtName.text.toString(),
      "address": txtAdress.text.toString(),
      "areaId": areaId.toString(),
      "mobile": txtMobile.text.toString(),
      "latLong": txtLatLng.text.toString().replaceAll("\t-\t", ","),
    };
    if (txtName.text.isNotEmpty && txtBillAmount.text.isNotEmpty && routesSelectedId.isNotEmpty) {
      finalCreateList = createList
          .where(
            (element) => (element["name"] == data["name"]),
          )
          .toList();
      finalCreateAddressList = addresses
          .where(
            (element) => (element["name"] == secondData["name"]),
          )
          .toList();
      if (finalCreateList.isEmpty && finalCreateAddressList.isEmpty) {
        createList.add(data);
        addresses.add(secondData);
        onCLear();
        Get.back();
      } else {
        onCLear();
        update();
        snackBar("Orders is allready available", Colors.deepOrange);
      }
    } else {
      if (txtName.text.isEmpty) {
        snackBar("Name is not available", Colors.deepOrange);
      } else if (txtBillAmount.text.isEmpty) {
        snackBar("BillAmount is not available", Colors.deepOrange);
      } else if (routesSelectedId.isEmpty) {
        snackBar("Area not available", Colors.deepOrange);
      } else if (routesSelectedId.isEmpty || txtBillAmount.text.isEmpty) {
        snackBar("Area & BillAmount not available", Colors.deepOrange);
      } else {
        snackBar("Name & BillNo & Area not available", Colors.deepOrange);
      }
    }
    update();
  }

  onRemoveOrders(orders) {
    if (orders != null) {
      Get.dialog(
        AlertDialog(
          title: Text(
            'Remove',
            style: AppCss.h1,
          ),
          content: Text(
            'Do you remove this orders?',
            style: AppCss.h3,
          ),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                createList.remove(orders);
                addresses.remove(secondData);
                update();
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Close"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
      update();
    }
  }

  onProceedOrder(context) async {
    await _saveShopOrder(context);
    update();
  }
}
