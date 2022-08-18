import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/request_address_edit_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:get/get.dart';

class RequestAddressEditScreen extends StatefulWidget {
  const RequestAddressEditScreen({Key? key}) : super(key: key);

  @override
  State<RequestAddressEditScreen> createState() => _RequestAddressEditScreenState();
}

class _RequestAddressEditScreenState extends State<RequestAddressEditScreen> {
  RequestAddressEditController requestAddressEditController = Get.put(RequestAddressEditController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestAddressEditController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          title: const Text("Request edit address"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                CommonOrdersTextCard(
                  name: "Routes",
                  hintText: requestAddressEditController.routesSelected != "" ? requestAddressEditController.routesSelected.capitalizeFirst.toString() : "",
                  readOnly: true,
                  suffixIcon: requestAddressEditController.routesSelected != ""
                      ? null
                      : const Icon(
                          Icons.arrow_drop_down,
                        ),
                  onTap: () {
                    commonBottomSheet(
                      context: context,
                      height: MediaQuery.of(context).size.height * 0.6,
                      widget: SearchableListView(
                        isLive: false,
                        isOnSearch: false,
                        isOnheder: true,
                        hederColor: Theme.of(context).primaryColor,
                        hederTxtColor: Colors.white,
                        itemList: requestAddressEditController.vendorRoutesList,
                        hederText: "Routes",
                        bindText: 'name',
                        bindValue: '_id',
                        labelText: 'Listing of global addresses.',
                        hintText: 'Please Select',
                        onSelect: (val, text, e) {
                          requestAddressEditController.selectedRoutes(val, text);
                        },
                      ),
                    );
                  },
                ),
                CommonOrdersTextCard(
                  name: "Business Name",
                  controller: requestAddressEditController.txtName,
                ),
                CommonOrdersTextCard(
                  name: "Mobile",
                  controller: requestAddressEditController.txtMobile,
                  keyboardType: TextInputType.number,
                ),
                CommonOrdersTextCard(
                  name: "lat-Long",
                  controller: requestAddressEditController.txtLatLng,
                ),
                CommonOrdersTextCard(
                  name: "Plus Code",
                  controller: requestAddressEditController.txtPlusCode,
                ),
                CommonOrdersTextCard(
                  name: "Address",
                  keyboardType: TextInputType.streetAddress,
                  controller: requestAddressEditController.txtAdress,
                  minLines: 1,
                  maxLines: 4,
                ),
                Row(
                  children: [
                    commonButton(
                      onTap: () => requestAddressEditController.onSubmit(context),
                      height: 50.0,
                      width: Get.width * 0.3,
                      color: Colors.green,
                      text: "Submit",
                    ),
                    commonButton(
                      onTap: () => requestAddressEditController.onClear(),
                      height: 50.0,
                      width: Get.width * 0.3,
                      color: Colors.red,
                      text: "Clear",
                    ),
                  ],
                ).paddingSymmetric(vertical: 20, horizontal: 5),
              ],
            ),
            if (requestAddressEditController.getAddress.isEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  NoDataWidget(
                    title: "No data !",
                    body: "No orders available",
                  ),
                ],
              ),
            if (requestAddressEditController.isLoading)
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
    );
  }
}
