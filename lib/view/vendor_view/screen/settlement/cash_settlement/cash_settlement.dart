import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_cash_settlement_card.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/cash_settlement_controller.dart';
import 'package:get/get.dart';

class CashSettlementScreen extends StatefulWidget {
  const CashSettlementScreen({Key? key}) : super(key: key);

  @override
  State<CashSettlementScreen> createState() => _CashSettlementScreenState();
}

class _CashSettlementScreenState extends State<CashSettlementScreen> {
  CashSettlementController cashSettlementController = Get.put(CashSettlementController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashSettlementController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return cashSettlementController.willPopScope();
        },
        child: LoadingMode(
          isLoading: cashSettlementController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Cash Settlement"),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  cashSettlementController.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    cashSettlementController.onSearchButtonTapped();
                  },
                  icon: Container(
                    color: cashSettlementController.searchButton ? Colors.redAccent : Theme.of(context).primaryColor,
                    child: Icon(
                      cashSettlementController.searchButton ? Icons.close : Icons.search,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(cashSettlementController.searchButton ? 50 : 0),
                child: cashSettlementController.searchButton
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: cashSettlementController.txtSearch,
                          focusNode: cashSettlementController.txtSearchFocus,
                          hintText: "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: GestureDetector(
                            onTap: () => cashSettlementController.onSearchAddress(),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blueGrey.withOpacity(0.8),
                              size: cashSettlementController.txtSearch.text != "" ? 15 : 20,
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
                          onEditingComplete: () => cashSettlementController.onSearchAddress(),
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
                        for (int i = 0; i < cashSettlementController.filters.length; i++)
                          CommonChips(
                            onTap: () => cashSettlementController.onChange(i),
                            color: cashSettlementController.filters[i]["isActive"] ? AppController().appTheme.primary.withOpacity(.8) : Colors.white,
                            text: cashSettlementController.filters[i]["label"].toString().capitalizeFirst,
                            style: AppCss.poppins.copyWith(
                              color:
                                  cashSettlementController.filters[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                            ),
                          ),
                      ],
                    ).paddingOnly(bottom: 10),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          cashSettlementController.onRefresh();
                        },
                        child: ListView(
                          children: [
                            if (cashSettlementController.codSettlementList.isNotEmpty)
                              ...cashSettlementController.codSettlementList.map(
                                (e) {
                                  return CommonCashSettlementCard(
                                    orderNo: e["desc"] != "" && e["desc"] != null ? e["desc"].toString() : "",
                                    personName: e["orderDetails"]["vendorOrderStatusId"]["addressId"]["name"] != "" &&
                                            e["orderDetails"]["vendorOrderStatusId"]["addressId"]["name"] != null
                                        ? e["orderDetails"]["vendorOrderStatusId"]["addressId"]["name"].toString()
                                        : "",
                                    address: e["orderDetails"]["vendorOrderStatusId"]["addressId"]["address"] != "" &&
                                            e["orderDetails"]["vendorOrderStatusId"]["addressId"]["address"] != null
                                        ? e["orderDetails"]["vendorOrderStatusId"]["addressId"]["address"].toString()
                                        : "",
                                    mobile: e["orderDetails"]["vendorOrderStatusId"]["addressId"]["mobile"] != "" &&
                                            e["orderDetails"]["vendorOrderStatusId"]["addressId"]["mobile"] != null
                                        ? e["orderDetails"]["vendorOrderStatusId"]["addressId"]["mobile"].toString()
                                        : "",
                                    date: e["orderDetails"]["vendorOrderStatusId"]["updatedAt"] != "" &&
                                            e["orderDetails"]["vendorOrderStatusId"]["updatedAt"] != null
                                        ? getFormattedDate(e["orderDetails"]["vendorOrderStatusId"]["updatedAt"].toString())
                                        : "",
                                    cashAmount: e["orderDetails"]["collectableCash"] != "" && e["orderDetails"]["collectableCash"] != null
                                        ? e["orderDetails"]["collectableCash"].toString()
                                        : "",
                                    receivedAmount: e["orderDetails"]["cashReceive"] != "" && e["orderDetails"]["cashReceive"] != null
                                        ? e["orderDetails"]["cashReceive"].toString()
                                        : "",
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (cashSettlementController.codSettlementList.isEmpty && !cashSettlementController.isLoading)
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
