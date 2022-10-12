import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_filter_dropdown_card.dart';
import 'package:fw_vendor/core/widgets/common/common_tickets_card.dart';
import 'package:fw_vendor/core/widgets/common/complaint_add_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/complaint_controller.dart';
import 'package:get/get.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  ComplaintController controller = Get.put(ComplaintController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplaintController>(
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
              title: const Text("Complaint"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  controller.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    controller.onAddButtonTapped();
                  },
                  icon: Container(
                    color: controller.isAdd ? Colors.green : Theme.of(context).primaryColor,
                    child: const Icon(Icons.add),
                  ),
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
                                hintText: controller.isAdd ? "Enter the BillNo" : "Search".tr,
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
                if (!controller.isAdd) _tapList(),
                if (controller.isAdd)
                  Expanded(
                    child: Column(
                      children: [
                        CommonFilterDropDown(
                          selectedName: controller.filters["area"]!["name"] != "" ? controller.filters["area"]!["name"] : 'Select Area',
                          onTap: () => controller.onAreaModule(),
                          bottom: 0,
                        ).paddingOnly(top: 10, right: 10, left: 10),
                        if (controller.isAreaON) _vendorAreaList(),
                        if (!controller.isAreaON) _complaintAddList(),
                      ],
                    ),
                  ),
                if (controller.startDateVendor != "" && controller.endDateVendor != "")
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${controller.startDateVendor} "
                      "- ${controller.endDateVendor}",
                      style: AppCss.h3,
                    ),
                  ).paddingOnly(left: 8, top: 5),
                if (!controller.isAdd) _complaintList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _tapList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < controller.tabs.length; i++)
          GestureDetector(
            onTap: () => controller.onTabChange(controller.tabs[i]),
            child: AnimatedContainer(
              height: 45,
              alignment: Alignment.center,
              margin: EdgeInsets.zero,
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: controller.selectedTab == controller.tabs[i] ? Theme.of(context).primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                controller.tabs[i],
                style: AppCss.h1.copyWith(
                  color: controller.selectedTab == controller.tabs[i] ? Theme.of(context).primaryColor : Colors.grey,
                  fontSize: controller.selectedTab == controller.tabs[i] ? 19 : 16,
                  fontWeight: controller.selectedTab == controller.tabs[i] ? null : FontWeight.w400,
                ),
              ),
            ),
          ),
      ],
    );
  }

  _complaintList() {
    return controller.getOrderTicketList.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
              controller: controller.scrollController,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.getOrderTicketList.length,
              itemBuilder: (BuildContext context, int index) {
                return CommonTicketsCard(
                  shopName: controller.getOrderTicketList[index]["addressId"]["name"],
                  reOpenStatus: controller.getOrderTicketList[index]["status"].toString().capitalizeFirst.toString(),
                  orderNo: controller.getOrderTicketList[index]["vendorOrderNo"],
                  addressDate: getFormattedDate2(controller.getOrderTicketList[index]["updatedAt"].toString()),
                  onPressed: () => controller.onTicketsView(controller.getOrderTicketList[index]),
                  onStatus: () => controller.onStatusCheck(controller.getOrderTicketList[index]),
                ).paddingAll(10);
              },
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

  _complaintAddList() {
    return controller.orderDetailsOrderTicketList.isNotEmpty
        ? Expanded(
            child: ListView(
              children: [
                ...controller.orderDetailsOrderTicketList.map((e) {
                  return ComplaintAddCard(
                    addressName: e["addressId"]["name"],
                    personName: e["addressId"]["person"],
                    mobile: e["addressId"]["mobile"],
                    address: e["addressId"]["address"],
                    billNo: e["billNo"],
                    orderNo: e["vendorOrderId"]["orderNo"],
                    notes: e["notes"],
                    anyNote: e["addressId"]["anyNote"],
                    driverNotes: e["vendorOrderId"]["driverNotes"],
                    onPressed: ()=>controller.resolvedOrders(e),
                  );
                }).toList(),
              ],
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
