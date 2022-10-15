// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_filter_dropdown_card.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/global_directory_controller.dart';
import 'package:get/get.dart';

class GlobalDirectoryScreen extends StatelessWidget {
  GlobalDirectoryScreen({Key? key}) : super(key: key);
  GlobalDirectoryController globalDirectoryController = Get.put(GlobalDirectoryController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalDirectoryController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return globalDirectoryController.willPopScope();
        },
        child: LoadingMode(
          isLoading: globalDirectoryController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Global Directory"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  globalDirectoryController.willPopScope();
                },
              ),
              actions: [
                if (globalDirectoryController.filters["area"]!["id"] != "")
                  IconButton(
                    onPressed: () {
                      globalDirectoryController.onSearchButtonTapped();
                    },
                    icon: Container(
                      color: globalDirectoryController.isSearch ? Colors.redAccent : Theme.of(context).primaryColor,
                      child: Icon(globalDirectoryController.isSearch ? Icons.close : Icons.search),
                    ),
                  ),
              ],
              bottom: globalDirectoryController.filters["area"]!["id"] != ""
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(globalDirectoryController.isSearch ? 50 : 0),
                      child: globalDirectoryController.isSearch
                          ? Container(
                              color: Colors.white,
                              child: CustomTextFormField(
                                container: globalDirectoryController.txtSearch,
                                focusNode: globalDirectoryController.txtSearchFocus,
                                hintText: "Search".tr,
                                fillColor: Colors.white,
                                prefixIcon: GestureDetector(
                                  onTap: () => globalDirectoryController.onSearchGlobalAddress(),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Colors.blueGrey.withOpacity(0.8),
                                    size: globalDirectoryController.txtSearch.text != "" ? 15 : 20,
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
                                onEditingComplete: () => globalDirectoryController.onSearchGlobalAddress(),
                              ),
                            )
                          : Container(),
                    )
                  : null,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    if (globalDirectoryController.vendorAreaList.isNotEmpty && globalDirectoryController.filters["area"]!["id"] == "")
                      CommonFilterDropDown(
                        selectedName: 'Select Area',
                        onTap: () => globalDirectoryController.onAreaModule(),
                        bottom: 0,
                      ).paddingOnly(top: 10, right: 10, left: 10),
                    if (globalDirectoryController.vendorAreaList.isNotEmpty && globalDirectoryController.filters["area"]!["id"] == "")
                      _vendorAreaList(),
                  ],
                ),
                if (globalDirectoryController.globalAddressesList.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 5, left: 5),
                        child: Text(globalDirectoryController.filters["area"]!["name"].toString(), style: AppCss.footnote.copyWith(fontSize: 16)),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            globalDirectoryController.onRefresh();
                          },
                          child: ListView(
                            padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).size.height * 0.06),
                            children: [
                              if (globalDirectoryController.globalAddressesList.isNotEmpty)
                                ...globalDirectoryController.globalAddressesList.map(
                                  (e) {
                                    return OrderAddressCard(
                                      addressHeder: e["name"].toString(),
                                      personName: e["person"].toString(),
                                      mobileNumber: e["mobile"].toString(),
                                      date: getFormattedDate(e["updatedAt"].toString()),
                                      address: e["address"],
                                      onTap: () {
                                        globalDirectoryController.addToSelectedList(e);
                                      },
                                      icon: e['selected'] == true ? true : false,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).paddingAll(10),
                if (globalDirectoryController.globalAddressesList.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: commonButton(
                      borderRadius: 0.0,
                      margin: EdgeInsets.zero,
                      onTap: () {
                        globalDirectoryController.onSelectedLocation();
                      },
                      color: globalDirectoryController.selectedOrderTrueList.isNotEmpty ? AppController().appTheme.primary1 : Colors.grey,
                      text: "Selected location (${globalDirectoryController.selectedOrderTrueList.length})",
                      height: 50.0,
                    ),
                  ),
                if (globalDirectoryController.globalAddressesList.isEmpty &&
                    globalDirectoryController.filters["area"]!["id"] != "" &&
                    !globalDirectoryController.isLoading)
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

  _vendorAreaList() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          ...globalDirectoryController.vendorAreaList.map(
            (e) => Column(
              children: [
                ListTile(
                  onTap: () {
                    globalDirectoryController.onSelectDropdown(e["_id"], e["name"], "area");
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
}
