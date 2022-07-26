// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/orders_controller.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_action_chip.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_details.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/common_dialog/scale_dialog.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({Key? key}) : super(key: key);
  OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            return ordersController.willPopScope();
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: Text(ordersController.status != null ? ordersController.status.toString().capitalizeFirst.toString() : "Pending"),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  ordersController.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ordersController.onSearchButtonTapped();
                  },
                  icon: Icon(ordersController.isSearch ? Icons.close : Icons.search),
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
                        itemList: ordersController.searchFilter,
                        hederText: "Filter",
                        bindText: 'title',
                        bindValue: '_id',
                        labelText: 'Listing of global addresses.',
                        hintText: 'Please Select',
                        onSelect: (val, text, e) {
                          ordersController.onFilterSelected(text);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.filter_alt_sharp),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(ordersController.isSearch ? 50 : 0),
                child: ordersController.isSearch
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: ordersController.txtSearch,
                          hintText: ordersController.filterSelected != "" ? ordersController.filterSelected : "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          padding: 15,
                          radius: 0,
                          maxLength: 10,
                          counterText: "",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            ordersController.onSearchOrders();
                          },
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < ordersController.filters.length; i++)
                      SizedBox(
                        height: 25,
                        child: CommonChips(
                          onTap: () => ordersController.onChange(i),
                          borderRadius: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: ordersController.filters[i]["isActive"] ? AppController().appTheme.primary.withOpacity(.8) : Colors.white,
                          text: ordersController.filters[i]["label"].toString().capitalizeFirst,
                          style: AppCss.poppins.copyWith(
                            color: ordersController.filters[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                          ),
                        ),
                      )
                  ],
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    ordersController.onRefresh();
                  },
                  child: ListView(
                    children: [
                      if (ordersController.ordersDetailsList.length != null)
                        ...ordersController.ordersDetailsList.map(
                          (e) {
                            ordersController.locationData = e;
                            return Column(
                              children: [
                                if (ordersController.ordersDetailsList != null && e["orderStatus"].length != 0)
                                  CommonOrdersDetails(
                                    orderNo: e["orderNo"] != "" ? e["orderNo"].toString() : "",
                                    orderType: e["orderType"] != "" ? e["orderType"].toString().toUpperCase() : "",
                                    date: e["updatedAt"] != "" ? getFormattedDate(e["updatedAt"].toString()) : "",
                                    locations: e["orderStatus"] != "" ? e["orderStatus"].length.toString() : "",
                                    locationClick: () {
                                      if (e["orderStatus"] != null) {
                                        ordersController.onLocationClick(e["orderStatus"]);
                                      } else {
                                        snackBar("No pacakge data found", Colors.deepOrange);
                                      }
                                    },
                                    items: Wrap(
                                      direction: Axis.horizontal,
                                      children: [
                                        if (e["deliveredCount"] != null)
                                          CommonActionChip(
                                            count: e['deliveryReport']["delivered"].length.toString(),
                                            status: e["deliveredCount"].toString(),
                                            color: Colors.green,
                                            onTap: () => ordersController.onLocationClick(e["deliveryReport"]["delivered"]),
                                          ),
                                        if (e["runningCount"] != null)
                                          CommonActionChip(
                                            count: e['deliveryReport']["running"].length.toString(),
                                            status: e["runningCount"].toString(),
                                            color: Colors.blueAccent,
                                            onTap: () => ordersController.onLocationClick(e["deliveryReport"]["running"]),
                                          ),
                                        if (e["returnedCount"] != null)
                                          CommonActionChip(
                                            count: e['deliveryReport']["returned"].length.toString(),
                                            status: e["returnedCount"].toString(),
                                            color: Colors.deepOrange.shade500,
                                            onTap: () => ordersController.onLocationClick(e["deliveryReport"]["returned"]),
                                          ),
                                        if (e["cancelledCount"] != null)
                                          CommonActionChip(
                                            count: e['deliveryReport']["cancelled"].length.toString(),
                                            status: e["cancelledCount"].toString(),
                                            color: Colors.red,
                                            onTap: () => ordersController.onLocationClick(e["deliveryReport"]["cancelled"]),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                    ],
                  ).paddingOnly(top: 30),
                ),
                if (ordersController.locationData != null && ordersController.locationData["orderStatus"].length == 0)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoDataWidget(
                        title: "No data !",
                        body: "No orders available",
                      ),
                    ],
                  ),
                if (ordersController.ordersDetailsList.isEmpty || ordersController.ordersDetailsList.length == null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoDataWidget(
                        title: "No data !",
                        body: "No orders available",
                      ),
                    ],
                  ),
                if (ordersController.isLoading)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white.withOpacity(.8),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ).paddingSymmetric(horizontal: 10, vertical: 10),
          ),
        );
      },
    );
  }
}
