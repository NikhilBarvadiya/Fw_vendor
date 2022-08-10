import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/create_global_orders_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:get/get.dart';

class CreateGlobalOrdersScreen extends StatefulWidget {
  const CreateGlobalOrdersScreen({Key? key}) : super(key: key);
  @override
  State<CreateGlobalOrdersScreen> createState() => _CreateGlobalOrdersScreenState();
}

class _CreateGlobalOrdersScreenState extends State<CreateGlobalOrdersScreen> {
  CreateGlobalOrdersCntroller createGlobalOrdersCntroller = Get.put(CreateGlobalOrdersCntroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateGlobalOrdersCntroller>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return createGlobalOrdersCntroller.willPopScope();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text(
              "Create B2B Order",
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                createGlobalOrdersCntroller.willPopScope();
              },
            ),
            actions: [
              // if (createGlobalOrdersCntroller.areaSelectedId != "")
              //   IconButton(
              //     onPressed: () {
              //       createGlobalOrdersCntroller.onSearchButtonTapped();
              //     },
              //     icon: Icon(createGlobalOrdersCntroller.isSearch ? Icons.close : Icons.search),
              //   ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(createGlobalOrdersCntroller.isSearch ? 50 : 0),
              child: createGlobalOrdersCntroller.isSearch
                  ? Container(
                      color: Colors.white,
                      child: CustomTextFormField(
                        container: createGlobalOrdersCntroller.txtSearch,
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
                          createGlobalOrdersCntroller.onSearchAddress();
                        },
                      ),
                    )
                  : Container(),
            ),
          ),
          body: Stack(
            children: [
              if (createGlobalOrdersCntroller.vendorAreaList.isNotEmpty && createGlobalOrdersCntroller.areaSelectedId == "")
                SearchableListView(
                  isLive: false,
                  isOnSearch: false,
                  isOnheder: false,
                  itemList: createGlobalOrdersCntroller.vendorAreaList,
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
                    createGlobalOrdersCntroller.onRouteSelected(val, text);
                  },
                ),
              if (createGlobalOrdersCntroller.areaSelectedId != "")
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 5, left: 5),
                      child: Text(
                        createGlobalOrdersCntroller.areaSelectedId,
                        style: AppCss.footnote.copyWith(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          if (createGlobalOrdersCntroller.vendorAddressesByAreaList.isNotEmpty)
                            ...createGlobalOrdersCntroller.vendorAddressesByAreaList.map(
                              (e) {
                                return OrderAddressCard(
                                  addressHeder: e["globalAddressId"]["name"].toString(),
                                  personName: e["globalAddressId"]["person"].toString(),
                                  mobileNumber: e["globalAddressId"]["mobile"].toString(),
                                  date: getFormattedDate(e["globalAddressId"]["updatedAt"].toString()),
                                  address: e["globalAddressId"]["address"],
                                  onTap: () {
                                    createGlobalOrdersCntroller.addToSelectedList(e);
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
                          createGlobalOrdersCntroller.onSelectedLocation();
                        },
                        text: "Selected location (${createGlobalOrdersCntroller.selectedOrderTrueList.length})",
                        height: 50.0,
                      ),
                    ),
                  ],
                ).paddingAll(10),
              if (createGlobalOrdersCntroller.vendorAddressesByAreaList.isEmpty && createGlobalOrdersCntroller.areaSelectedId != "")
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    NoDataWidget(
                      title: "No data !",
                      body: "No orders available",
                    ),
                  ],
                ),
              if (createGlobalOrdersCntroller.isLoading)
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
