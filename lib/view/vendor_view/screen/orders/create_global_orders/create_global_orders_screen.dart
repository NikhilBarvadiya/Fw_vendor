import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_filter_dropdown_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
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
  CreateGlobalOrdersController createGlobalOrdersController = Get.put(CreateGlobalOrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateGlobalOrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return createGlobalOrdersController.willPopScope();
        },
        child: LoadingMode(
          isLoading: createGlobalOrdersController.isLoading,
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
                  createGlobalOrdersController.willPopScope();
                },
              ),
              actions: [
                if (createGlobalOrdersController.filters["area"]!["id"] != "")
                  IconButton(
                    onPressed: () {
                      createGlobalOrdersController.onSearchButtonTapped();
                    },
                    icon: Container(
                      color: createGlobalOrdersController.isSearch ? Colors.redAccent : Theme.of(context).primaryColor,
                      child: Icon(
                        createGlobalOrdersController.isSearch ? Icons.close : Icons.search,
                      ),
                    ),
                  ),
              ],
              bottom: createGlobalOrdersController.filters["area"]!["id"] != ""
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(createGlobalOrdersController.isSearch ? 50 : 0),
                      child: createGlobalOrdersController.isSearch
                          ? Container(
                              color: Colors.white,
                              child: CustomTextFormField(
                                container: createGlobalOrdersController.txtSearch,
                                focusNode: createGlobalOrdersController.txtSearchFocus,
                                hintText: "Search".tr,
                                fillColor: Colors.white,
                                prefixIcon: GestureDetector(
                                  onTap: () => createGlobalOrdersController.filterSearch(),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Colors.blueGrey.withOpacity(0.8),
                                    size: createGlobalOrdersController.txtSearch.text != "" ? 15 : 20,
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
                                onChanged: (_) => createGlobalOrdersController.filterSearch(),
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
                    if (createGlobalOrdersController.vendorAreaList.isNotEmpty && createGlobalOrdersController.filters["area"]!["id"] == "")
                      CommonFilterDropDown(
                        selectedName: 'Select Area',
                        onTap: () => createGlobalOrdersController.onAreaModule(),
                        bottom: 0,
                      ).paddingOnly(top: 10, right: 10, left: 10),
                    if (createGlobalOrdersController.vendorAreaList.isNotEmpty && createGlobalOrdersController.filters["area"]!["id"] == "")
                      _vendorAreaList(),
                  ],
                ),
                if (createGlobalOrdersController.filteredList.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 5, left: 5),
                        child: Text(
                          createGlobalOrdersController.filters["area"]!["name"].toString(),
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
                            if (createGlobalOrdersController.filteredList.isNotEmpty)
                              ...createGlobalOrdersController.filteredList.map(
                                (e) {
                                  return OrderAddressCard(
                                    addressHeder: e["globalAddressId"]["name"].toString(),
                                    personName: e["globalAddressId"]["person"].toString(),
                                    mobileNumber: e["globalAddressId"]["mobile"].toString(),
                                    date: getFormattedDate(e["globalAddressId"]["updatedAt"].toString()),
                                    address: e["globalAddressId"]["address"],
                                    onTap: () {
                                      createGlobalOrdersController.addToSelectedList(e);
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
                if (createGlobalOrdersController.filteredList.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: commonButton(
                      onTap: () {
                        createGlobalOrdersController.onSelectedLocation();
                      },
                      borderRadius: 0.0,
                      margin: EdgeInsets.zero,
                      color: createGlobalOrdersController.selectedOrderTrueList.isNotEmpty ? AppController().appTheme.primary1 : Colors.grey,
                      text: "Selected location (${createGlobalOrdersController.selectedOrderTrueList.length})",
                      height: 50.0,
                    ),
                  ),
                if (createGlobalOrdersController.filteredList.isEmpty &&
                    createGlobalOrdersController.filters["area"]!["id"] != "" &&
                    !createGlobalOrdersController.isLoading)
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
          ...createGlobalOrdersController.vendorAreaList.map(
                (e) => Column(
              children: [
                ListTile(
                  onTap: () {
                    createGlobalOrdersController.onSelectDropdown(e["_id"], e["name"], "area");
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
