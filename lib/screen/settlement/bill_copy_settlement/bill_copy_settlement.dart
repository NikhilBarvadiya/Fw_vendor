import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/bill_copy_controller.dart';
import 'package:get/get.dart';

class BillCopySettementScreen extends StatefulWidget {
  const BillCopySettementScreen({Key? key}) : super(key: key);

  @override
  State<BillCopySettementScreen> createState() => _BillCopySettementScreenState();
}

class _BillCopySettementScreenState extends State<BillCopySettementScreen> {
  BillCopySettlementController billCopySettlementController = Get.put(BillCopySettlementController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillCopySettlementController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return billCopySettlementController.willPopScope();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text("Bill Copy Settlement"),
          ),
        ),
      ),
    );
  }
}
