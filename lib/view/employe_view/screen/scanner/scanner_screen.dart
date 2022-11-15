import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fw_vendor/view/employe_view/controller/scanner_controller.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  ScannerController scannerController = Get.put(ScannerController());

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      scannerController.qrViewController!.pauseCamera();
    }
    scannerController.qrViewController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScannerController>(
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _buildQrView(context),
      ),
    );
  }

  _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 200) ? 350.0 : 200.0;
    return Stack(
      children: [
        QRView(
          key: scannerController.qrKey,
          onQRViewCreated: scannerController.onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea,
            borderColor: Theme.of(context).primaryColor,
          ),
          onPermissionSet: (ctrl, p) => scannerController.onPermissionSet(context, ctrl, p),
        ),
        if (scannerController.isSuccess == true)
          Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Colors.red.withOpacity(0.2)),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => scannerController.onFlash(),
              child: Card(
                color: Theme.of(context).primaryColor,
                child: const SizedBox(height: 50, width: 50, child: Icon(Icons.flash_on_rounded, color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
