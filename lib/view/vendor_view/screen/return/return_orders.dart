import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_filter_dropdown_card.dart';
import 'package:fw_vendor/core/widgets/common/return_orders_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/view/vendor_view/controller/return_orders_controller.dart';
import 'package:get/get.dart';

class ReturnOrdersScreen extends StatefulWidget {
  const ReturnOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ReturnOrdersScreen> createState() => _ReturnOrdersScreenState();
}

class _ReturnOrdersScreenState extends State<ReturnOrdersScreen> {
  ReturnOrdersController controller = Get.put(ReturnOrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnOrdersController>(
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
              title: const Text("Return Orders"),
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
                    child: Icon(controller.isSearch ? Icons.close : Icons.search),
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
                                  onTap: () => controller.onSearchOrders(),
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
                                onEditingComplete: () => controller.onSearchOrders(),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.customDate(),
                              child: Card(
                                elevation: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Icon(Icons.date_range, size: 25, color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      if (controller.isFilter)
                        CommonFilterDropDown(
                          selectedName: 'Select Route',
                          onTap: () => controller.onRoutesModule(),
                          bottom: 0,
                        ).paddingOnly(top: 10, right: 10, left: 10),
                      if (controller.startDateVendor != "" && controller.endDateVendor != "")
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${controller.startDateVendor} "
                            "- ${controller.endDateVendor}",
                            style: AppCss.h3,
                          ),
                        ).paddingOnly(left: 10, top: 5),
                      if (controller.isRoutesON) _routesList(),
                      if (!controller.isRoutesON) _returnOrdersCard(),
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
      child: Column(
        children: [
          Expanded(
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
                        leading: Icon(e["selected"] != null && e["selected"] != false ? Icons.check_box : Icons.check_box_outline_blank),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: commonButton(
              margin: EdgeInsets.zero,
              borderRadius: 0.0,
              color: controller.routeIdList.isNotEmpty ? AppController().appTheme.primary1 : Colors.grey,
              onTap: () => controller.onSelected(),
              text: "Selected routes (${controller.routeIdList.length})",
              height: 50.0,
            ),
          ),
        ],
      ),
    );
  }

  _returnOrdersCard() {
    return controller.returnOrderDetailsList.isNotEmpty
        ? Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.onRefresh(),
              ),
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                controller: controller.scrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.returnOrderDetailsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReturnOrdersCard(
                    addressName: controller.returnOrderDetailsList[index]["addressId"]["name"].toString(),
                    personName: controller.returnOrderDetailsList[index]["addressId"]["person"].toString(),
                    mobile: controller.returnOrderDetailsList[index]["addressId"]["mobile"].toString(),
                    address: controller.returnOrderDetailsList[index]["addressId"]["address"].toString(),
                    billNo: controller.returnOrderDetailsList[index]["billNo"],
                    notes: controller.returnOrderDetailsList[index]["notes"],
                    anyNote: controller.returnOrderDetailsList[index]["anyNote"],
                    driverNotes: controller.returnOrderDetailsList[index]["driverNotes"],
                  );
                },
              ),
            ),
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!controller.isLoading)
                  const NoDataWidget(
                    title: "No data !",
                    body: "No orders available",
                  ),
              ],
            ),
          );
  }
}
