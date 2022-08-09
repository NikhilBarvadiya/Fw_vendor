import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common/common_request_address_chip.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class PlaceOrdersController extends GetxController {
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtBillNumber = TextEditingController();
  TextEditingController txtCash = TextEditingController();
  TextEditingController txtLoose = TextEditingController();
  TextEditingController txtBox = TextEditingController();
  TextEditingController txtNotes = TextEditingController();
  List selectedOrderList = [];
  List edit = [];
  bool isLoading = false;
  bool isPaymentMode = false;
  @override
  void onInit() {
    selectedOrderList = Get.arguments;
    super.onInit();
  }

  _onClear() {
    txtAmount.clear();
    txtBillNumber.clear();
    txtCash.clear();
    txtLoose.clear();
    txtBox.clear();
    txtNotes.clear();
    isPaymentMode = false;
    update();
  }

  willPopScope() {
    _onClear();
    edit.clear();
    selectedOrderList.clear();
    Get.toNamed(AppRoutes.createGlobalOrdersScreen);
  }

  onCredit() {
    if (txtAmount.text.isNotEmpty) {
      txtCash.text = txtAmount.text;
    } else {
      txtAmount.text = txtCash.text;
    }
    if (txtAmount.text.isNotEmpty && txtCash.text.isNotEmpty) {
      isPaymentMode = true;
    }
    update();
  }

  onCash() {
    if (txtBox.text.isNotEmpty || txtCash.text.isNotEmpty) {
      txtAmount.text = "";
    }
    isPaymentMode = false;
    update();
  }

  onEdit(context, index) {
    List editCheck = [];
    commonBottomSheet(
      context: context,
      widget: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonOrdersTextCard(
                name: "Bill Number",
                controller: txtBillNumber,
                keyboardType: TextInputType.number,
                hederStyle: AppCss.footnote.copyWith(
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Losse pakage",
                      controller: txtLoose,
                      keyboardType: TextInputType.number,
                      hederStyle: AppCss.footnote.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Box pakage",
                      controller: txtBox,
                      keyboardType: TextInputType.number,
                      hederStyle: AppCss.footnote.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Bill Amount",
                      controller: txtCash,
                      keyboardType: TextInputType.number,
                      hederStyle: AppCss.footnote.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Amount",
                      controller: txtAmount,
                      keyboardType: TextInputType.number,
                      hederStyle: AppCss.footnote.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  CommonRequestAddressChips(
                    status: isPaymentMode != true ? "Credit" : "COD",
                    color: Colors.white,
                    backgroundColor: isPaymentMode != true ? Colors.blueAccent : Colors.green,
                    onTap: () {
                      isPaymentMode != true ? onCredit() : onCash();
                      setState(() {});
                    },
                  ).paddingOnly(top: 5, right: 5),
                ],
              ),
              CommonOrdersTextCard(
                name: "Notes",
                controller: txtNotes,
                hederStyle: AppCss.footnote.copyWith(
                  fontSize: 15,
                ),
              ),
              commonButton(
                onTap: () {
                  var data = {
                    "_id": index,
                    "billNo": txtBillNumber.text != "" ? txtBillNumber.text.toString() : "0",
                    "amount": txtAmount.text != "" ? txtAmount.text.toString() : "0",
                    "cash": txtCash.text != "" ? txtCash.text.toString() : "0",
                    "paymentMethod": isPaymentMode != true ? "credit" : "COD",
                    "nOfBoxes": txtBox.text != "" ? txtBox.text.toString() : "0",
                    "nOfPackages": txtLoose.text != "" ? txtLoose.text.toString() : "0",
                    "notes": txtNotes.text != "" ? txtNotes.text.toString() : "---",
                  };
                  editCheck = edit
                      .where(
                        (element) => (element["_id"] == data["_id"]),
                      )
                      .toList();
                  if (editCheck.isEmpty) {
                    edit.add(data);
                    _onClear();
                    Get.back();
                  } else {
                    edit.removeAt(index);
                    edit.insert(index, data);
                    _onClear();
                    Get.back();
                  }
                  update();
                },
                text: "Done",
                height: 50.0,
              ).paddingAll(10),
            ],
          ).paddingSymmetric(vertical: 10);
        },
      ),
    );
  }

  onPlaceOrder(selectedAddress, context) async {
    try {
      isLoading = true;
      update();
      List ordersRequest = [];
      for (int i = 0; i < selectedAddress.length; i++) {
        ordersRequest.add({
          "addressId": selectedAddress[i]["globalAddressId"]["_id"],
          "amount": edit.isNotEmpty && edit.length > i && edit[i]["_id"] == i ? edit[i]["amount"].toString() : "0",
          "areaId": selectedAddress[i]["globalAddressId"]["routeId"]["areaId"],
          "billNo": edit.isNotEmpty && edit.length > i && edit[i]["_id"] == i ? edit[i]["billNo"].toString() : "0",
          "businessCategoryId": selectedAddress[i]["globalAddressId"]["businessCategoryId"],
          "cash": edit.isNotEmpty && edit.length > i && edit[i]["_id"] == i ? edit[i]["cash"].toString() : "0",
          "nOfBoxes": edit.isNotEmpty && edit.length > i && edit[i]["_id"] == i ? edit[i]["nOfBoxes"].toString() : "0",
          "nOfPackages": edit.isNotEmpty && edit.length > i && edit[i]["_id"] == i ? edit[i]["nOfPackages"].toString() : "0",
          "orderType": "b2b",
          "routeId": selectedAddress[i]["globalAddressId"]["routeId"]["_id"],
        });
      }
      var data = {
        "ordersRequest": ordersRequest,
      };
      var resData = await apis.call(
        apiMethods.saveOrder,
        data,
        ApiType.post,
      );
      if (resData.isSuccess && resData.data != 0) {
        stylishDialog(
          context: context,
          alertType: StylishDialogType.SUCCESS,
          titleText: 'Update succes',
          contentText: resData.message.toString(),
          confirmButton: Colors.green,
          onPressed: () {
            willPopScope();
          },
        );
      }
    } catch (e) {
      snackBar("No pacakge data found", Colors.red);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }
}
