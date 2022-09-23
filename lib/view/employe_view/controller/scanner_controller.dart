// ignore_for_file: deprecated_member_use, non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:vibration/vibration.dart';

class ScannerController extends GetxController {
  Barcode? result;
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void onInit() {
    onQRViewCreated;
    super.onInit();
  }

  // Scanner view.......

  void onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    if (Platform.isAndroid) {
      qrViewController!.pauseCamera();
    }
    qrViewController!.resumeCamera();
    update();
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      if (result != null) {
        if (result!.code!.contains("partyCode")) {
          try {
            var json = result!.code;
            var finalJSON = "${json!.substring(0, json.length - 2)}}";
            qrViewController!.stopCamera();
            Vibration.vibrate(duration: 300);
            await _verifyOrder(jsonDecode(finalJSON));
          } catch (e) {
            stylishDialog(
              context: Get.context,
              alertType: StylishDialogType.ERROR,
              contentText: "Invalid Format",
              confirmButton: Colors.redAccent,
              onPressed: () {
                Get.back();
                qrViewController!.resumeCamera();
              },
            );
          }
        } else {
          qrViewController!.stopCamera();
          stylishDialog(
            context: Get.context,
            alertType: StylishDialogType.ERROR,
            contentText: "Invalid OR Detected",
            confirmButton: Colors.redAccent,
            onPressed: () {
              Get.back();
              qrViewController!.resumeCamera();
            },
          );
        }
      }
      update();
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  onFlash() async {
    await qrViewController!.toggleFlash();
    update();
  }

  // Api calling by scanner......

  _verifyOrder(shopName) async {
    try {
      var request = shopName;
      var resData = await apis.call(
        apiMethods.verifyOrder,
        request,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        qrViewController!.pauseCamera();
        Get.toNamed(AppRoutes.verifyOrder, arguments: {
          "shopName": shopName,
          "data": resData.data,
        })!
            .then((value) {
          qrViewController!.resumeCamera();
        });
      } else {
        stylishDialog(
          context: Get.context,
          alertType: StylishDialogType.INFO,
          contentText: resData.message.toString(),
          confirmButton: Colors.green,
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        );
      }
    } catch (e) {
      stylishDialog(
        context: Get.context,
        alertType: StylishDialogType.INFO,
        contentText: e.toString(),
        confirmButton: Colors.green,
        onPressed: () {
          Get.back();
          qrViewController!.resumeCamera();
        },
      );
    }
    update();
  }
}
