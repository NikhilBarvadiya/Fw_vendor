import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/common/common_filter_dropdown_card.dart';
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
  DraftOrdersController controller = Get.put(DraftOrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DraftOrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return controller.willPopScope();
        },
        child: LoadingMode(
          isLoading: controller.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Your Draft Orders"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  controller.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    controller.onFilterButtonTapped();
                  },
                  icon: Icon(controller.isFilter ? Icons.filter_alt_off : Icons.filter_alt_sharp, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    controller.onSearchButtonTapped();
                  },
                  icon: Container(
                    color: controller.isSearch ? Colors.redAccent : Theme.of(context).primaryColor,
                    child: Icon(controller.isSearch ? Icons.close : Icons.search, color: Colors.white),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(controller.isSearch ? 50 : 0),
                child: controller.isSearch
                    ? Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                  container: controller.txtSearch,
                                  focusNode: controller.txtSearchFocus,
                                  hintText: "Search".tr,
                                  fillColor: Colors.white,
                                  prefixIcon: GestureDetector(
                                    onTap: () {
                                      controller.onSearchOrders();
                                    },
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: Colors.blueGrey.withOpacity(0.8),
                                      size: controller.txtSearch.text != "" ? 15 : 20,
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
                                  onEditingComplete: () => controller.onSearchOrders()),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    for (int i = 0; i < controller.dateFilter.length; i++)
                      Container(
                        height: 25,
                        padding: const EdgeInsets.only(right: 5),
                        child: CommonChips(
                          onTap: () => controller.onChange(i),
                          borderRadius: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: controller.dateFilter[i]["isActive"] ? AppController().appTheme.primary.withOpacity(.8) : Colors.white,
                          text: controller.dateFilter[i]["label"].toString().capitalizeFirst,
                          style: AppCss.poppins.copyWith(
                            color: controller.dateFilter[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                          ),
                        ),
                      ),
                  ],
                ).paddingAll(10),
                Expanded(
                  child: Column(
                    children: [
                      if (controller.isFilter)
                        Row(
                          children: [
                            Expanded(
                              child: CommonFilterDropDown(
                                selectedName: 'Select Route',
                                onTap: () => controller.onRoutesModule(),
                                backgroundColor: controller.isRoutesON ? Theme.of(context).primaryColor : Colors.white,
                                borderColor: controller.isRoutesON ? Colors.white : Colors.blueGrey.withOpacity(0.8),
                                bottom: 0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CommonFilterDropDown(
                                selectedName: 'Select Area',
                                onTap: () => controller.onAreaModule(),
                                backgroundColor: controller.isAreaON ? Theme.of(context).primaryColor : Colors.white,
                                borderColor: controller.isAreaON ? Colors.white : Colors.blueGrey.withOpacity(0.8),
                                bottom: 0,
                              ),
                            ),
                          ],
                        ).paddingOnly(left: 10, right: 10),
                      if (controller.isRoutesON) _routesList(),
                      if (controller.isAreaON) _vendorAreaList(),
                      if (controller.getDraftOrderList.isNotEmpty) _vendorDraftList(),
                      if (controller.getDraftOrderList.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: commonButton(
                            margin: EdgeInsets.zero,
                            borderRadius: 0.0,
                            color: controller.selectedOrderList.isNotEmpty ? AppController().appTheme.primary1 : Colors.grey,
                            onTap: () => controller.onProceed(controller.selectedOrderList),
                            text: "Proceed Addresses (${controller.selectedOrderList.length})",
                            height: 50.0,
                          ),
                        ),
                      if (controller.getDraftOrderList.isEmpty && !controller.isRoutesON && !controller.isAreaON)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.getDraftOrderList.isEmpty && !controller.isLoading)
                                const NoDataWidget(
                                  title: "No data !",
                                  body: "No orders available",
                                ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _routesList() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          ...controller.vendorRoutesList.map(
            (e) => Column(
              children: [
                ListTile(
                  onTap: () {
                    controller.onSelectDropdown(e["_id"], e["name"], "route");
                  },
                  leading: Icon(e["selected"] != null && e["selected"] != false ? Icons.radio_button_on_outlined : Icons.radio_button_off_sharp),
                  selectedColor: e["selected"] != null ? Colors.blue : Colors.black,
                  selected: e["selected"] != false ? true : false,
                  title: Text(
                    e["name"].toString().capitalizeFirst.toString(),
                    style: AppCss.body2.copyWith(
                      fontSize: e["selected"] != null && e["selected"] != false ? 14 : 12,
                      fontWeight: e["selected"] != null && e["selected"] != false ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _vendorAreaList() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          ...controller.vendorAreaList.map(
            (e) => Column(
              children: [
                ListTile(
                  onTap: () {
                    controller.onSelectDropdown(e["_id"], e["name"], "area");
                  },
                  leading: Icon(e["selected"] != null && e["selected"] != false ? Icons.radio_button_on_outlined : Icons.radio_button_off_sharp),
                  selectedColor: e["selected"] != null ? Colors.blue : Colors.black,
                  selected: e["selected"] != false ? true : false,
                  title: Text(
                    e["name"].toString().capitalizeFirst.toString(),
                    style: AppCss.body2.copyWith(
                      fontSize: e["selected"] != null && e["selected"] != false ? 14 : 12,
                      fontWeight: e["selected"] != null && e["selected"] != false ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _vendorDraftList() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.06),
        shrinkWrap: true,
        children: [
          ...controller.getDraftOrderList.map(
            (e) {
              var index = controller.getDraftOrderList.indexOf(e);
              return Slidable(
                key: ValueKey(index),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => controller.onNotes(e, context),
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
                      onPressed: (_) => controller.onDeleteOrders(e, context),
                      backgroundColor: Colors.redAccent.shade100,
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (_) => controller.onEdit(e),
                      backgroundColor: Colors.blueAccent.shade100.withOpacity(0.5),
                      foregroundColor: Colors.blue,
                      icon: FontAwesomeIcons.expeditedssl,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: CommonDraftOrdersCard(
                  onTap: () => controller.addToSelectedList(e, context),
                  name: e["addressId"]["name"] != null && e["addressId"]["name"] != "" ? e["addressId"]["name"].toString() : "",
                  address: e["addressId"]["address"] != null && e["addressId"]["address"] != "" ? e["addressId"]["address"].toString() : "",
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
    );
  }
}
