// ignore_for_file: deprecated_member_use, non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:vibration/vibration.dart';

class ScannerController extends GetxController {
  Barcode? result;
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isSuccess = false;

  @override
  void onInit() {
    onQRViewCreated;
    super.onInit();
  }

  void onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    if (Platform.isAndroid) {
      qrViewController!.pauseCamera();
    }
    qrViewController!.resumeCamera();
    update();
    dynamic req;
    controller.scannedDataStream.listen(
      (scanData) async {
        result = scanData;
        if (result!.code!.contains("partyCode") == false) {
          var json = "${result!.code}";
          var Mobile = json.split("\$")[2].substring(0).replaceAll(RegExp(r'\s+\b|\b\s'), " ").toString().trimRight();
          var BillNo = json.split("\$")[3].substring(0).replaceAll(RegExp(r'\s+\b|\b\s'), " ").toString().trimRight();
          req = {
            "ShopName": json.split("\$")[0].substring(0).replaceAll(RegExp(r'\s+\b|\b\s'), " ").toString().trimRight(),
            "Address": json.split("\$")[1].substring(0).replaceAll(RegExp(r'\s+\b|\b\s'), " ").toString().trimRight(),
            "Mobile": Mobile.replaceAll("Phone:", "").toString().trimLeft(),
            "BillNo": BillNo.replaceAll("Bill No.", "").toString().trimLeft(),
          };
          log(req.toString());
        }
        if (result != null) {
          if (result!.code!.contains("partyCode")) {
            try {
              var json = result!.code;
              dynamic finalJSON = "${json!.substring(0, json.length - 2)}}";
              qrViewController!.stopCamera();
              Vibration.vibrate(duration: 300);
              await _verifyOrder(jsonDecode(finalJSON));
            } catch (e) {
              scannerErrorDialog(
                contentText: "Invalid Format",
                onPressed: () {
                  Get.back();
                  qrViewController!.resumeCamera();
                },
              );
            }
          } else if (req["ShopName"] != null && req["Address"] != null && req["BillNo"] != null) {
            try {
              qrViewController!.stopCamera();
              Vibration.vibrate(duration: 300);
              await _verifyOrder(req);
            } catch (e) {
              scannerErrorDialog(
                contentText: "Invalid Format",
                onPressed: () {
                  Get.back();
                  qrViewController!.resumeCamera();
                },
              );
            }
          } else {
            qrViewController!.stopCamera();
            scannerErrorDialog(
              contentText: "Invalid QR Detected",
              onPressed: () {
                Get.back();
                qrViewController!.resumeCamera();
              },
            );
          }
        }
        update();
      },
    );
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

  _verifyOrder(req) async {
    try {
      if (req['shopName'] != null) {
        req = {
          "ShopName": req["shopName"],
          "partyCode": req['partyCode'],
          'BillNo': req['billNo'],
          'Amount': req['amount'],
          'FirmGSTIN': req['firmGSTIN']
        };
      }
      var request = req;
      var resData = await apis.call(apiMethods.verifyOrder, request, ApiType.post);
      if (resData.isSuccess == true && resData.data != 0 && resData.data != 2) {
        qrViewController!.pauseCamera();
        Get.toNamed(AppRoutes.verifyOrder, arguments: {"scannerData": req, "index": 0, "data": resData.data})!.then((value) {
          qrViewController!.resumeCamera();
        });
      } else if (resData.isSuccess == true && resData.data == 2) {
        successDialog(
          titleText: "Information",
          contentText: "This requested address already available!",
          alertType: StylishDialogType.INFO,
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
            update();
          },
        );
      } else {
        successDialog(
          titleText: "Information",
          contentText: "This address is not mapped please add request to continue!",
          alertType: StylishDialogType.INFO,
          onCancel: () {
            Get.back();
            qrViewController!.resumeCamera();
            update();
          },
          onPressed: () {
            Get.back();
            qrViewController!.pauseCamera();
            Get.toNamed(AppRoutes.verifyOrder, arguments: {"scannerData": req, "index": 1})!.then((value) {
              qrViewController!.resumeCamera();
            });
          },
        );
      }
    } catch (e) {
      isSuccess = true;
      scannerErrorDialog(
        contentText: e.toString(),
        onPressed: () {
          Get.back();
          qrViewController!.resumeCamera();
        },
      );
    }
    update();
  }
}
