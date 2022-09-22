// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/save_address_controller.dart';
import 'package:get/get.dart';

class SaveAddressScreen extends StatelessWidget {
  SaveAddressScreen({Key? key}) : super(key: key);
  SaveAddressController saveAddressController = Get.put(SaveAddressController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaveAddressController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return saveAddressController.willPopScope();
        },
        child: LoadingMode(
          isLoading: saveAddressController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              backgroundColor: saveAddressController.isMapper ? Colors.deepOrange : Theme.of(context).primaryColor,
              title: Text(
                saveAddressController.isMapper ? "Mapped addresses" : "Saved addresses",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textScaleFactor: 1,
                textAlign: TextAlign.center,
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  if (saveAddressController.isMapper) {
                    saveAddressController.onMapperModeBack();
                  } else {
                    saveAddressController.willPopScope();
                  }
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    saveAddressController.onSearchButtonTapped();
                  },
                  icon: Container(
                    color: saveAddressController.isMapper
                        ? saveAddressController.isSearch
                            ? Colors.white
                            : Colors.deepOrange
                        : saveAddressController.isSearch
                            ? Colors.redAccent
                            : Theme.of(context).primaryColor,
                    child: Icon(
                      saveAddressController.isSearch ? Icons.close : Icons.search,
                      color: saveAddressController.isMapper
                          ? saveAddressController.isSearch
                              ? Colors.deepOrange
                              : Colors.white
                          : Colors.white,
                    ),
                  ),
                ),
                !saveAddressController.isMapper
                    ? PopupMenuButton(
                        onSelected: (value) {
                          saveAddressController.onMapperButtonTapped();
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Show mapped addresses",
                              style: AppCss.body3,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(saveAddressController.isSearch ? 50 : 0),
                child: saveAddressController.isSearch
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: saveAddressController.txtSearch,
                          focusNode: saveAddressController.txtSearchFocus,
                          hintText: "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: GestureDetector(
                            onTap: () {
                              if (saveAddressController.isMapper) {
                                saveAddressController.onSearchMapperAddress();
                              } else {
                                saveAddressController.onSearchAddress();
                              }
                            },
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blueGrey.withOpacity(0.8),
                              size: saveAddressController.txtSearch.text != "" ? 15 : 20,
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
                          onEditingComplete: () {
                            if (saveAddressController.isMapper) {
                              saveAddressController.onSearchMapperAddress();
                            } else {
                              saveAddressController.onSearchAddress();
                            }
                          },
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    if (saveAddressController.saveAddressList.isNotEmpty && saveAddressController.isMapper != true) {
                      saveAddressController.onRefresh();
                    }
                    if (saveAddressController.mappedAddressList.isNotEmpty && saveAddressController.isMapper != false) {
                      saveAddressController.onRefreshMapper();
                    }
                  },
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: MediaQuery.of(context).size.height * 0.06,
                    ),
                    children: [
                      if (saveAddressController.saveAddressList.isNotEmpty && saveAddressController.isMapper != true)
                        ...saveAddressController.saveAddressList.map(
                          (e) {
                            return OrderAddressCard(
                              addressHeder: e["globalAddressId"]["name"].toString(),
                              personName: e["globalAddressId"]["person"].toString(),
                              mobileNumber: e["globalAddressId"]["mobile"].toString(),
                              date: getFormattedDate(e["globalAddressId"]["updatedAt"].toString()),
                              address: e["globalAddressId"]["address"],
                              area: e["globalAddressId"]["routeId"]["areaId"]["name"].toString().capitalizeFirst,
                              iconSize: 22,
                              icon: true,
                              cardColors: Colors.white,
                              onTap: () {
                                saveAddressController.onDeleteClick(e, e["_id"]);
                              },
                            );
                          },
                        ),
                      if (saveAddressController.mappedAddressList.isNotEmpty && saveAddressController.isMapper != false)
                        ...saveAddressController.mappedAddressList.map(
                          (e) {
                            return OrderAddressCard(
                              addressHeder: e["globalAddressId"]["name"].toString(),
                              personName: e["globalAddressId"]["person"].toString(),
                              mobileNumber: e["globalAddressId"]["mobile"].toString(),
                              date: getFormattedDate(e["globalAddressId"]["updatedAt"].toString()),
                              address: e["globalAddressId"]["address"],
                              area: e["globalAddressId"]["routeId"]["areaId"]["name"].toString().capitalizeFirst,
                              yourAddress: e["addressName"].toString().capitalizeFirst,
                              iconSize: 22,
                              icon: true,
                              cardColors: Colors.white,
                              type: e["type"].toString().capitalizeFirst,
                              onTypeClick: () {
                                saveAddressController.onTypeClick(e["_id"]);
                              },
                              onTap: () {
                                saveAddressController.onDeleteMappedClick(e, e["_id"]);
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
                if (saveAddressController.saveAddressList.isEmpty && saveAddressController.isMapper != true && !saveAddressController.isLoading)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoDataWidget(
                        title: "No data !",
                        body: "No orders available",
                      ),
                    ],
                  ),
                if (saveAddressController.mappedAddressList.isEmpty && saveAddressController.isMapper != false && !saveAddressController.isLoading)
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
            ).paddingAll(10),
          ),
        ),
      ),
    );
  }
}
