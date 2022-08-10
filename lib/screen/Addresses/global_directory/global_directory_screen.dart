// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/global_directory_controller.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
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
                      child: ListView(
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
                                  deleteIcon: e['selected'] == null
                                      ? Icons.add
                                      : e['selected'] == true
                                          ? Icons.check
                                          : Icons.add,
                                  icon: e['selected'] == null
                                      ? false
                                      : e['selected'] == true
                                          ? true
                                          : false,
                                  deleteIconColor: Colors.black,
                                  deleteIconBoxColor: AppController().appTheme.green,
                                  cardColors: e['selected'] == true ? Colors.green[100] : Colors.white,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: commonButton(
                        onTap: () {
                          globalDirectoryController.onSelectedLocation();
                        },
                        text: "Selected location (${globalDirectoryController.selectedOrderTrueList.length})",
                        height: 50.0,
                      ),
                    ),
                  ],
                ).paddingAll(10),
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
              if (globalDirectoryController.isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(.8),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
