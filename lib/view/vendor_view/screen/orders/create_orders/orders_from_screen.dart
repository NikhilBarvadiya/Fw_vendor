import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common/common_request_address_chip.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/vendor_view/controller/orders_create_controller.dart';
import 'package:get/get.dart';

class OrdersFromScreen extends StatefulWidget {
  const OrdersFromScreen({Key? key}) : super(key: key);

  @override
  State<OrdersFromScreen> createState() => _OrdersFromScreenState();
}

class _OrdersFromScreenState extends State<OrdersFromScreen> {
  OrdersCreateController ordersCreateController = Get.put(OrdersCreateController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersCreateController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return ordersCreateController.willPopScopeCreateOrdersForms();
        },
        child: LoadingMode(
          isLoading: ordersCreateController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text(
                "Create B2C Order",
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  ordersCreateController.willPopScopeCreateOrdersForms();
                },
              ),
            ),
            body: Stack(
              children: [
                ListView(
                  children: [
                    CommonOrdersTextCard(
                      name: "Name",
                      controller: ordersCreateController.txtName,
                      focusNode: ordersCreateController.txtNameFocus,
                      readOnly: true,
                      suffixIcon: ordersCreateController.txtName.text != "" ? null : const Icon(Icons.arrow_drop_down),
                      onTap: () {
                        ordersCreateController.onCLear();
                        commonBottomSheet(
                          context: context,
                          widget: SearchableListView(
                            isLive: false,
                            isOnSearch: true,
                            isOnheder: false,
                            isDivider: false,
                            txtController: ordersCreateController.txtName,
                            itemList: ordersCreateController.customerAddressNameList,
                            bindText: "name",
                            bindValue: '_id',
                            labelText: 'Listing of customer Name.',
                            hintText: 'Please Select',
                            onSelect: (val, text, e) {
                              ordersCreateController.onNameSelected(val, text);
                            },
                          ),
                        );
                      },
                    ),
                    CommonOrdersTextCard(
                      name: "Address",
                      keyboardType: TextInputType.streetAddress,
                      controller: ordersCreateController.txtAddress,
                      focusNode: ordersCreateController.txtAddressFocus,
                      minLines: 1,
                      maxLines: 4,
                    ),
                    CommonOrdersTextCard(
                      name: "Area",
                      hintText: ordersCreateController.routesSelected != "" ? ordersCreateController.routesSelected.capitalizeFirst.toString() : "",
                      readOnly: true,
                      suffixIcon: ordersCreateController.routesSelected != "" ? null : const Icon(Icons.arrow_drop_down),
                      onTap: () {
                        commonBottomSheet(
                          context: context,
                          height: MediaQuery.of(context).size.height * 0.6,
                          widget: SearchableListView(
                            isLive: false,
                            isOnSearch: false,
                            isOnheder: true,
                            isDivider: false,
                            hederColor: Theme.of(context).primaryColor,
                            hederTxtColor: Colors.white,
                            itemList: ordersCreateController.vendorRoutesList,
                            hederText: "Routes",
                            bindText: 'name',
                            bindValue: '_id',
                            labelText: 'Listing of global addresses.',
                            hintText: 'Please Select',
                            onSelect: (val, text, e) {
                              ordersCreateController.onRoutesSelected(val, text, e);
                            },
                          ),
                        );
                      },
                    ),
                    CommonOrdersTextCard(
                      name: "Mobile",
                      controller: ordersCreateController.txtMobile,
                      focusNode: ordersCreateController.txtMobileFocus,
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonOrdersTextCard(
                            name: "Bill No",
                            controller: ordersCreateController.txtBillNo,
                            focusNode: ordersCreateController.txtBillNoFocus,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          child: CommonOrdersTextCard(
                            name: "Loose Pkg",
                            keyboardType: TextInputType.number,
                            controller: ordersCreateController.txtLoosePkg,
                            focusNode: ordersCreateController.txtLoosePkgFocus,
                          ),
                        ),
                        Expanded(
                          child: CommonOrdersTextCard(
                            name: "Box Pkg",
                            keyboardType: TextInputType.number,
                            controller: ordersCreateController.txtBoxPkg,
                            focusNode: ordersCreateController.txtBoxPkgFocus,
                          ),
                        ),
                      ],
                    ),
                    CommonOrdersTextCard(
                      name: "Notes",
                      controller: ordersCreateController.txtNotes,
                      focusNode: ordersCreateController.txtNotesFocus,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonOrdersTextCard(
                            name: "Amount",
                            keyboardType: TextInputType.number,
                            controller: ordersCreateController.txtAmount,
                            focusNode: ordersCreateController.txtAmountFocus,
                          ),
                        ),
                        Expanded(
                          child: CommonOrdersTextCard(
                            name: "Bill Amount",
                            keyboardType: TextInputType.number,
                            controller: ordersCreateController.txtBillAmount,
                            focusNode: ordersCreateController.txtBillAmountFocus,
                          ),
                        ),
                        CommonRequestAddressChips(
                          status: ordersCreateController.isPaymentMode != true ? "Credit" : "COD",
                          color: Colors.white,
                          backgroundColor: ordersCreateController.isPaymentMode != true ? Colors.blueAccent : Colors.green,
                          onTap: () =>
                          ordersCreateController.isPaymentMode != true ? ordersCreateController.onCredit() : ordersCreateController.onCash(),
                        ).paddingOnly(top: 5, right: 5),
                      ],
                    ),
                    CommonOrdersTextCard(
                      name: "lat-Long",
                      controller: ordersCreateController.txtLatLng,
                      focusNode: ordersCreateController.txtLatLngFocus,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: commonButton(
                    margin: EdgeInsets.zero,
                    borderRadius: 0.0,
                    onTap: () => ordersCreateController.onCreateOrder(),
                    text: "Create order",
                    height: 50.0,
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
