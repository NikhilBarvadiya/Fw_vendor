import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/return_order_settlement_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/common/common_retrun_orders_settement_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:get/get.dart';

class ReturnOrderSettlementScreen extends StatefulWidget {
  const ReturnOrderSettlementScreen({Key? key}) : super(key: key);
  @override
  State<ReturnOrderSettlementScreen> createState() => _ReturnOrderSettlementScreenState();
}

class _ReturnOrderSettlementScreenState extends State<ReturnOrderSettlementScreen> {
  ReturnOrderSettlementController returnOrderSettlementController = Get.put(ReturnOrderSettlementController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnOrderSettlementController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return returnOrderSettlementController.willPopScope();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text("Return Order Settlement"),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < returnOrderSettlementController.filters.length; i++)
                        CommonChips(
                          onTap: () => returnOrderSettlementController.onChange(i),
                          color: returnOrderSettlementController.filters[i]["isActive"] ? AppController().appTheme.primary.withOpacity(.8) : Colors.white,
                          text: returnOrderSettlementController.filters[i]["label"].toString().capitalizeFirst,
                          style: AppCss.poppins.copyWith(
                            color: returnOrderSettlementController.filters[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                          ),
                        ),
                    ],
                  ).paddingOnly(bottom: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        if (returnOrderSettlementController.returnOrderSettlementList.isNotEmpty)
                          ...returnOrderSettlementController.returnOrderSettlementList.map(
                            (e) {
                              return CommonReturnOrderSettlementCard(
                                orderNo: e["vendorOrderId"]["orderNo"] != "" && e["vendorOrderId"]["orderNo"] != null ? e["vendorOrderId"]["orderNo"].toString() : "",
                                personName: e["addressId"] != "" && e["addressId"] != null ? e["addressId"]["name"].toString() : e["name"].toString(),
                                address: e["addressId"] != "" && e["addressId"] != null ? e["addressId"]["address"].toString() : e["address"].toString(),
                                mobile: e["addressId"] != "" && e["addressId"] != null ? e["addressId"]["mobile"].toString() : e["mobile"].toString(),
                                date: e["vendorOrderId"]["updatedAt"] != "" && e["vendorOrderId"]["updatedAt"] != null ? getFormattedDate(e["vendorOrderId"]["updatedAt"].toString()) : "",
                                cashAmount: e["cash"] != "" && e["cash"] != null ? e["cash"].toString() : "",
                                billNo: e["billNo"] != "" && e["billNo"] != null ? e["billNo"].toString() : "",
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (returnOrderSettlementController.returnOrderSettlementList.isEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    NoDataWidget(
                      title: "No data !",
                      body: "No orders available",
                    ),
                  ],
                ),
              if (returnOrderSettlementController.isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(.8),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ).paddingAll(10),
        ),
      ),
    );
  }
}
