import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_retrun_orders_settement_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/return_order_settlement_controller.dart';
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
        child: LoadingMode(
          isLoading: returnOrderSettlementController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Return Order Settlement"),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  returnOrderSettlementController.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    returnOrderSettlementController.onSearchButtonTapped();
                  },
                  icon: Container(
                    color: returnOrderSettlementController.isSearch ? Colors.redAccent : Theme.of(context).primaryColor,
                    child: Icon(
                      returnOrderSettlementController.isSearch ? Icons.close : Icons.search,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(returnOrderSettlementController.isSearch ? 50 : 0),
                child: returnOrderSettlementController.isSearch
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: returnOrderSettlementController.txtSearch,
                          focusNode: returnOrderSettlementController.txtSearchFocus,
                          hintText: "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: GestureDetector(
                            onTap: () => returnOrderSettlementController.onSearch(),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blueGrey.withOpacity(0.8),
                              size: returnOrderSettlementController.txtSearch.text != "" ? 15 : 20,
                            ),
                          ),
                          padding: 15,
                          radius: 0,
                          counterText: "",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                          onEditingComplete: () => returnOrderSettlementController.onSearch(),
                        ),
                      )
                    : Container(),
              ),
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
                            color: returnOrderSettlementController.filters[i]["isActive"]
                                ? AppController().appTheme.primary.withOpacity(.8)
                                : Colors.white,
                            text: returnOrderSettlementController.filters[i]["label"].toString().capitalizeFirst,
                            style: AppCss.poppins.copyWith(
                              color: returnOrderSettlementController.filters[i]["isActive"]
                                  ? Colors.white
                                  : AppController().appTheme.primary1.withOpacity(.8),
                            ),
                          ),
                      ],
                    ).paddingOnly(bottom: 10),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          returnOrderSettlementController.onRefresh();
                        },
                        child: ListView(
                          children: [
                            if (returnOrderSettlementController.returnOrderSettlementList.isNotEmpty)
                              ...returnOrderSettlementController.returnOrderSettlementList.map(
                                (e) {
                                  return CommonReturnOrderSettlementCard(
                                    orderNo: e["vendorOrderId"]["orderNo"] != "" && e["vendorOrderId"]["orderNo"] != null
                                        ? e["vendorOrderId"]["orderNo"].toString()
                                        : "",
                                    personName:
                                        e["addressId"] != "" && e["addressId"] != null ? e["addressId"]["name"].toString() : e["name"].toString(),
                                    address: e["addressId"] != "" && e["addressId"] != null
                                        ? e["addressId"]["address"].toString()
                                        : e["address"].toString(),
                                    mobile:
                                        e["addressId"] != "" && e["addressId"] != null ? e["addressId"]["mobile"].toString() : e["mobile"].toString(),
                                    date: e["vendorOrderId"]["updatedAt"] != "" && e["vendorOrderId"]["updatedAt"] != null
                                        ? getFormattedDate(e["vendorOrderId"]["updatedAt"].toString())
                                        : "",
                                    cashAmount: e["cash"] != "" && e["cash"] != null ? e["cash"].toString() : "",
                                    billNo: e["billNo"] != "" && e["billNo"] != null ? e["billNo"].toString() : "",
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (returnOrderSettlementController.returnOrderSettlementList.isEmpty && !returnOrderSettlementController.isLoading)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoDataWidget(
                        title: "No data !",
                        body: "No orders available",
                      ),
                    ],
                  ),
              ],
            ).paddingAll(10),
          ),
        ),
      ),
    );
  }
}
