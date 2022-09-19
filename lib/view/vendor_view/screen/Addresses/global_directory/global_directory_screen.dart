// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/common_controller/app_controller.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
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
              title: const Text(
                "Global Directory",
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  globalDirectoryController.willPopScope();
                },
              ),
              actions: [
                if (globalDirectoryController.areaSelected != "")
                  IconButton(
                    onPressed: () {
                      globalDirectoryController.onSearchButtonTapped();
                    },
                    icon: Icon(globalDirectoryController.isSearch ? Icons.close : Icons.search),
                  ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(globalDirectoryController.isSearch ? 50 : 0),
                child: globalDirectoryController.isSearch
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: globalDirectoryController.txtSearch,
                          focusNode: globalDirectoryController.txtSearchFocus,
                          hintText: "Search".tr,
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
                            globalDirectoryController.onSearchglobalAddress();
                          },
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                if (globalDirectoryController.vendorAreaList.isNotEmpty && globalDirectoryController.areaSelected == "")
                  SearchableListView(
                    isLive: false,
                    isOnSearch: false,
                    isOnheder: false,
                    isDivider: true,
                    itemList: globalDirectoryController.vendorAreaList,
                    hederText: "Area",
                    bindText: 'name',
                    bindValue: '_id',
                    hederColor: Theme.of(context).primaryColor,
                    hederTxtColor: Colors.white,
                    bindTextStyle: AppCss.body3.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    onSelect: (val, text, e) {
                      globalDirectoryController.onRouteSelected(val, text);
                    },
                  ),
                if (globalDirectoryController.areaSelected != "")
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 5, left: 5),
                        child: Text(
                          globalDirectoryController.areaSelectedId,
                          style: AppCss.footnote.copyWith(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            globalDirectoryController.onRefresh();
                          },
                          child: ListView(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: MediaQuery.of(context).size.height * 0.06,
                            ),
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
                if (globalDirectoryController.areaSelected != "")
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
                if (globalDirectoryController.globalAddressesList.isEmpty && globalDirectoryController.areaSelected != "")
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
