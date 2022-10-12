import 'package:flutter/material.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class RequestComplaintEditController extends GetxController {
  TextEditingController txtName = TextEditingController();
  FocusNode txtNameFocus = FocusNode();
  TextEditingController txtMobile = TextEditingController();
  FocusNode txtMobileFocus = FocusNode();
  TextEditingController txtLatLng = TextEditingController();
  FocusNode txtLatLngFocus = FocusNode();
  TextEditingController txtPlusCode = TextEditingController();
  FocusNode txtPlusFocus = FocusNode();
  TextEditingController txtAddress = TextEditingController();
  FocusNode txtAddressFocus = FocusNode();
  String routesSelected = "";
  String routesSelectedId = "";
  bool isLoading = false;
  List vendorRoutesList = [];

  screenFocus() {
    txtNameFocus.unfocus();
    txtMobileFocus.unfocus();
    txtLatLngFocus.unfocus();
    txtPlusFocus.unfocus();
    txtAddressFocus.unfocus();
    routesSelected = "";
    txtName.text = "";
    txtMobile.text = "";
    txtLatLng.text = "";
    txtPlusCode.text = "";
    txtAddress.text = "";
    update();
  }

  onSubmit(context) async {
    // await _vendorSetAddressRequest();
    stylishDialog(
      context: context,
      alertType: StylishDialogType.SUCCESS,
      titleText: 'Request Complaint',
      contentText: "Request Updated Successfully.",
      confirmButton: Colors.green,
      onPressed: () {
        Get.back();
        update();
        Get.offNamedUntil(AppRoutes.requestComplaintScreen, (Route<dynamic> route) => false);
      },
    );
    update();
  }
}
