import 'package:flutter/material.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/create_global_orders_controller.dart';
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
        child: LoadingMode(
          isLoading: createGlobalOrdersCntroller.isLoading,
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
            ),
            body: Stack(
              children: [
                if (createGlobalOrdersCntroller.vendorAreaList.isNotEmpty && createGlobalOrdersCntroller.areaSelectedId == "")
                  SearchableListView(
                    isLive: false,
                    isOnSearch: false,
                    isOnheder: false,
                    isDivider: true,
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
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: MediaQuery.of(context).size.height * 0.06,
                          ),
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
                                    icon: e['selected'] == true ? true : false,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ).paddingAll(10),
                if (createGlobalOrdersCntroller.areaSelectedId != "")
                Align(
                  alignment: Alignment.bottomCenter,
                  child: commonButton(
                    onTap: () {
                      createGlobalOrdersCntroller.onSelectedLocation();
                    },
                    borderRadius: 0.0,
                    margin: EdgeInsets.zero,
                    color: createGlobalOrdersCntroller.selectedOrderTrueList.isNotEmpty ? AppController().appTheme.primary1 : Colors.grey,
                    text: "Selected location (${createGlobalOrdersCntroller.selectedOrderTrueList.length})",
                    height: 50.0,
                  ),
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
