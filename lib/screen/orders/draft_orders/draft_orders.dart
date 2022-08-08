import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/draft_orders_controller.dart';
import 'package:get/get.dart';

class DraftOrderScreen extends StatefulWidget {
  const DraftOrderScreen({Key? key}) : super(key: key);

  @override
  State<DraftOrderScreen> createState() => _DraftOrderScreenState();
}

class _DraftOrderScreenState extends State<DraftOrderScreen> {
  DraftOrdersController draftOrdersController = Get.put(DraftOrdersController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DraftOrdersController>(
      builder: (_) => Scaffold(
        appBar: AppBar(),
      ),
    );
  }
}
