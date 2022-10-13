import 'package:flutter/material.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get.dart';

class RequestComplaintController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  FocusNode txtSearchFocus = FocusNode();
  bool isLoading = false;
  bool isSearch = true;


  willPopScope() {
    Get.offNamedUntil(AppRoutes.home, (route) => false);
  }

  onSearchButtonTapped() {
    if (isSearch && txtSearch.text != "") {
      txtSearch.text = "";
    }
    isSearch = !isSearch;
    update();
  }

  // _screenFocus() {
  //   txtSearch.text = "";
  //   txtSearchFocus.unfocus();
  // }

  onSearchAddress() async {
    txtSearchFocus.unfocus();
    // await _vendorRequestedAddress();
    update();
  }

  onRequestAddressDelete(id, address) async {
    isLoading = true;
    txtSearchFocus.unfocus();
    isLoading = false;
    Get.dialog(
      AlertDialog(
        title: Text('Remove', style: AppCss.h1),
        content: Text('Do you remove this address?', style: AppCss.h3),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () async {
              // vendorRequestAddressList.remove(address);
              // await _vendorDeleteRequestedAddress(id);
              update();
              Get.back();
            },
          ),
          TextButton(child: const Text("Close"), onPressed: () => Get.back()),
        ],
      ),
    );
    update();
  }

  onRequestAddressEdit(address) {
    txtSearchFocus.unfocus();
    Get.toNamed(AppRoutes.requestComplaintEditScreen, arguments: address);
  }
}
