import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/common/common_filter_dropdown_card.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_draftOrders_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/view/vendor_view/controller/draft_orders_controller.dart';
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
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return draftOrdersController.willPopScope();
        },
        child: LoadingMode(
          isLoading: draftOrdersController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Your Draft Orders"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  draftOrdersController.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    draftOrdersController.onFilterButtonTapped();
                  },
                  icon: const Icon(Icons.filter_alt_sharp),
                ),
                IconButton(
                  onPressed: () {
                    draftOrdersController.onSearchButtonTapped();
                  },
                  icon: Container(
                    color: draftOrdersController.isSearch ? Colors.redAccent : Theme.of(context).primaryColor,
                    child: Icon(draftOrdersController.isSearch ? Icons.close : Icons.search, color: Colors.white),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(draftOrdersController.isSearch ? 50 : 0),
                child: draftOrdersController.isSearch
                    ? Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                  container: draftOrdersController.txtSearch,
                                  focusNode: draftOrdersController.txtSearchFocus,
                                  hintText: "Search".tr,
                                  fillColor: Colors.white,
                                  prefixIcon: GestureDetector(
                                    onTap: () {
                                      draftOrdersController.onSearchOrders();
                                    },
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: Colors.blueGrey.withOpacity(0.8),
                                      size: draftOrdersController.txtSearch.text != "" ? 15 : 20,
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
                                  onEditingComplete: () => draftOrdersController.onSearchOrders()),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                if (draftOrdersController.isFilter)
                  Column(
                    children: [
                      CommonFilterDropDown(
                        onTap: () {
                          commonBottomSheet(
                            context: context,
                            widget: SearchableListView(
                              isLive: false,
                              isOnSearch: true,
                              itemList: [],
                              bindText: 'name',
                              bindValue: '_id',
                              labelText: 'Area',
                              hintText: 'Please Select',
                              onSelect: (id, title) {
                                draftOrdersController.onSelectDropdown(id, title, "area");
                              },
                            ),
                          );
                        },
                        selectedName: 'Select Area',
                      ),
                      CommonFilterDropDown(
                        onTap: () {
                          commonBottomSheet(
                            context: context,
                            widget: SearchableListView(
                              isLive: false,
                              isOnSearch: true,
                              itemList: [],
                              bindText: 'name',
                              bindValue: '_id',
                              labelText: 'Route',
                              hintText: 'Please Select',
                              onSelect: (id, title) {
                                draftOrdersController.onSelectDropdown(id, title, "route");
                              },
                            ),
                          );
                        },
                        selectedName: 'Select Route',
                      ),
                    ],
                  ).paddingOnly(left: 10, right: 10, top: 50),
                Row(
                  children: [
                    for (int i = 0; i < draftOrdersController.dateFilter.length; i++)
                      Container(
                        height: 25,
                        padding: const EdgeInsets.only(right: 5),
                        child: CommonChips(
                          onTap: () => draftOrdersController.onChange(i),
                          borderRadius: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: draftOrdersController.dateFilter[i]["isActive"] ? AppController().appTheme.primary.withOpacity(.8) : Colors.white,
                          text: draftOrdersController.dateFilter[i]["label"].toString().capitalizeFirst,
                          style: AppCss.poppins.copyWith(
                            color: draftOrdersController.dateFilter[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                          ),
                        ),
                      ),
                  ],
                ).paddingAll(10),
                if (draftOrdersController.getDraftOrderList.isNotEmpty)
                  ListView(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: MediaQuery.of(context).size.height * 0.06,
                    ),
                    children: [
                      ...draftOrdersController.getDraftOrderList.map(
                        (e) {
                          var index = draftOrdersController.getDraftOrderList.indexOf(e);
                          return Slidable(
                            key: ValueKey(index),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) => draftOrdersController.onNotes(e, context),
                                  backgroundColor: Colors.deepOrangeAccent.shade100.withOpacity(0.5),
                                  foregroundColor: Colors.deepOrange,
                                  icon: FontAwesomeIcons.solidMessage,
                                  label: 'Notes',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) => draftOrdersController.onDeleteOrders(e, context),
                                  backgroundColor: Colors.redAccent.shade100,
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                                SlidableAction(
                                  onPressed: (_) => draftOrdersController.onEdit(e),
                                  backgroundColor: Colors.blueAccent.shade100.withOpacity(0.5),
                                  foregroundColor: Colors.blue,
                                  icon: FontAwesomeIcons.expeditedssl,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            child: CommonDraftOrdersCard(
                              onTap: () => draftOrdersController.addToSelectedList(e, context),
                              name: e["addressId"]["name"] != null && e["addressId"]["name"] != "" ? e["addressId"]["name"].toString() : "",
                              address:
                                  e["addressId"]["address"] != null && e["addressId"]["address"] != "" ? e["addressId"]["address"].toString() : "",
                              billNumber: e["billNo"] != null && e["billNo"] != "" ? e["billNo"].toString() : "",
                              loose: e["nOfPackages"] != null && e["nOfPackages"] != "" ? e["nOfPackages"].toString() : "",
                              box: e["nOfBoxes"] != null && e["nOfBoxes"] != "" ? e["nOfBoxes"].toString() : "",
                              billAmount: e["amount"] != null && e["amount"] != "" ? e["amount"].toString() : "",
                              amount: e["cash"] != null && e["cash"] != "" ? e["cash"].toString() : "",
                              notes: e["anyNote"] != null && e["anyNote"] != "" ? e["anyNote"].toString() : "",
                              type: e["type"] != null && e["type"] != "" ? e["type"].toString().capitalizeFirst.toString() : "",
                              color: e['selected'] == true ? Colors.greenAccent[100] : Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ).paddingAll(10),
                if (draftOrdersController.getDraftOrderList.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: commonButton(
                      margin: EdgeInsets.zero,
                      borderRadius: 0.0,
                      color: draftOrdersController.selectedOrderList.isNotEmpty ? AppController().appTheme.primary1 : Colors.grey,
                      onTap: () => draftOrdersController.onProceed(draftOrdersController.selectedOrderList),
                      text: "Proceed Addresses (${draftOrdersController.selectedOrderList.length})",
                      height: 50.0,
                    ),
                  ),
                if (draftOrdersController.getDraftOrderList.isEmpty && !draftOrdersController.isLoading)
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
