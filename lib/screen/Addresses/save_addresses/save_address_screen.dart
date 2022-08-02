// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/save_address_controller.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
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
            leading: saveAddressController.isMapper
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      saveAddressController.onMapperModeBack();
                    },
                  )
                : null,
            actions: [
              IconButton(
                onPressed: () {
                  saveAddressController.onSearchButtonTapped();
                },
                icon: Icon(saveAddressController.isSearch ? Icons.close : Icons.search),
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
                        onChanged: (val) {},
                      ),
                    )
                  : Container(),
            ),
          ),
          body: Stack(
            children: [
              ListView(
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
                          deleteIcon: Icons.close,
                          iconSize: 22,
                          deleteIconBoxColor: Colors.red,
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
                          deleteIcon: Icons.close,
                          iconSize: 22,
                          deleteIconBoxColor: Colors.red,
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
              if (saveAddressController.saveAddressList.isEmpty && saveAddressController.isMapper != true)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    NoDataWidget(
                      title: "No data !",
                      body: "No orders available",
                    ),
                  ],
                ),
              if (saveAddressController.isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(.8),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ).paddingAll(10),
        ),
      ),
    );
  }
}
