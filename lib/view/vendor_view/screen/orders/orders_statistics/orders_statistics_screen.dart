import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_filter_dropdown_card.dart';
import 'package:fw_vendor/core/widgets/common/orders_statistics_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/view/vendor_view/controller/orders_statistics_controller.dart';
import 'package:get/get.dart';

class OrdersStatisticsScreen extends StatefulWidget {
  const OrdersStatisticsScreen({Key? key}) : super(key: key);

  @override
  State<OrdersStatisticsScreen> createState() => _OrdersStatisticsScreenState();
}

class _OrdersStatisticsScreenState extends State<OrdersStatisticsScreen> {
  OrdersStatisticsController controller = Get.put(OrdersStatisticsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersStatisticsController>(
      builder: (_) => LoadingMode(
        isLoading: controller.isLoading,
        child: WillPopScope(
          onWillPop: () async {
            return controller.willPopScope();
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Orders Statistics"),
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
                                keyboardType: TextInputType.number,
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
                        ).paddingOnly(left: 10, right: 10,top: 10),
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
                      if (controller.isAreaON) _vendorAreaList(),
                      if (controller.statisticsOrdersList.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              elevation: 1,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              color: Colors.amber,
                              child: Row(
                                children: [
                                  Text(
                                    "Total Location\t",
                                    style: AppCss.footnote.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
                                  ),
                                  Text(controller.total["totalLocation"] != null ? controller.total["totalLocation"].toString() : "00"),
                                ],
                              ).paddingOnly(left: 5, right: 5),
                            ),
                            Card(
                              elevation: 1,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              color: Colors.amber,
                              child: Row(
                                children: [
                                  Text(
                                    "Total Package\t",
                                    style: AppCss.footnote.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
                                  ),
                                  Text(controller.total["totalPkg"] != null ? controller.total["totalPkg"].toString() : "00"),
                                ],
                              ).paddingOnly(left: 5, right: 5),
                            ),
                            Card(
                              elevation: 1,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              color: Colors.amber,
                              child: Row(
                                children: [
                                  Text(
                                    "Total Boxes\t",
                                    style: AppCss.footnote.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
                                  ),
                                  Text(controller.total["totalBox"] != null ? controller.total["totalBox"].toString() : "00"),
                                ],
                              ).paddingOnly(left: 5, right: 5),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 10),
                      if (controller.statisticsOrdersList.isNotEmpty)
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                            children: [
                              ...controller.statisticsOrdersList.map((e) {
                                return OrdersStatisticsCard(
                                  totalPKG: e["totalPkgs"].toString(),
                                  totalBOX: e["totalBoxes"].toString(),
                                  date: getFormattedDate2(e["createdAt"].toString()),
                                  table: _tableSheet(e),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
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
    );
  }

  _tableSheet(data) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ...data["data"].map((e) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e["orderNo"].toString()),
                          Text(getFormattedDate2(e["createdAt"].toString()), style: AppCss.caption.copyWith(color: Colors.black)),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Total PKG",
                          style: AppCss.footnote.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          e["totalPkg"].toString(),
                          style: AppCss.h3.copyWith(color: Colors.black),
                        ),
                      ],
                    ).paddingOnly(right: 15),
                    Column(
                      children: [
                        Text(
                          "Total BOX",
                          style: AppCss.footnote.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          e["totalBox"].toString(),
                          style: AppCss.h3.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ).paddingOnly(left: 5, right: 5),
                Divider(color: Theme.of(context).primaryColor),
              ],
            );
          }).toList(),
          Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.56,
                  child: Text(
                    "Total",
                    style: AppCss.h3.copyWith(color: Colors.white),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  alignment: Alignment.center,
                  child: Text(
                    data["totalPkgs"].toString(),
                    style: AppCss.h3.copyWith(color: Colors.white),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  alignment: Alignment.center,
                  child: Text(
                    data["totalBoxes"].toString(),
                    style: AppCss.h3.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ).paddingOnly(left: 10, top: 10, bottom: 10),
          ),
        ],
      ),
    ).paddingAll(10);
  }
}
