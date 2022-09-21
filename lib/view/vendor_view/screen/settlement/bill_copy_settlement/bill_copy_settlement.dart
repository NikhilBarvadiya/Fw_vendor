import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/view/vendor_view/controller/bill_copy_controller.dart';
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
        child: LoadingMode(
          isLoading: billCopySettlementController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Bill Copy Settlement"),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  billCopySettlementController.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    billCopySettlementController.onSearchButtonTapped();
                  },
                  icon: Icon(billCopySettlementController.isSearch ? Icons.close : Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    commonBottomSheet(
                      context: context,
                      height: MediaQuery.of(context).size.height * 0.341,
                      margin: 0.0,
                      widget: SearchableListView(
                        isLive: false,
                        isOnSearch: false,
                        isOnheder: true,
                        isDivider: false,
                        itemList: billCopySettlementController.searchFilter,
                        hederText: "Filter",
                        bindText: 'title',
                        bindValue: '_id',
                        labelText: 'Listing of global addresses.',
                        hintText: 'Please Select',
                        onSelect: (val, text, e) {
                          billCopySettlementController.onFilterSelected(text);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.filter_alt_sharp),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(billCopySettlementController.isSearch ? 50 : 0),
                child: billCopySettlementController.isSearch
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: billCopySettlementController.txtSearch,
                          focusNode: billCopySettlementController.txtSearchFocus,
                          hintText: billCopySettlementController.filterSelected != "" ? billCopySettlementController.filterSelected : "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: GestureDetector(
                            onTap: () => billCopySettlementController.onSearchOrders(),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blueGrey.withOpacity(0.8),
                              size: billCopySettlementController.txtSearch.text != "" ? 15 : 20,
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
                          onEditingComplete: () => billCopySettlementController.onSearchOrders(),
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Column(
              children: [
                if (billCopySettlementController.billDetailsList.isNotEmpty)
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
            ),
          ),
        ),
      ),
    );
  }
}
