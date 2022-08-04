import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/orders_create_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common/common_request_address_chip.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
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
          return ordersCreateController.willPopScopeCreateOrdersFroms();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text(
              "Create orders",
            ),
          ),
          body: ListView(
            children: [
              CommonOrdersTextCard(
                name: "Name",
                controller: ordersCreateController.txtName,
                readOnly: true,
                onTap: () {
                  ordersCreateController.onCLear();
                  commonBottomSheet(
                    context: context,
                    widget: SearchableListView(
                      isLive: false,
                      isOnSearch: true,
                      isOnheder: false,
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
                controller: ordersCreateController.txtAdress,
                minLines: 1,
                maxLines: 4,
              ),
              CommonOrdersTextCard(
                name: "Area",
                hintText: ordersCreateController.routesSelected != "" ? ordersCreateController.routesSelected.capitalizeFirst.toString() : "",
                readOnly: true,
                suffixIcon: ordersCreateController.routesSelected != ""
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
                keyboardType: TextInputType.number,
              ),
              CommonOrdersTextCard(
                name: "Bill No",
                controller: ordersCreateController.txtBillNo,
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Loose Pkg",
                      keyboardType: TextInputType.number,
                      controller: ordersCreateController.txtLoosePkg,
                    ),
                  ),
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Box Pkg",
                      keyboardType: TextInputType.number,
                      controller: ordersCreateController.txtBoxPkg,
                    ),
                  ),
                ],
              ),
              CommonOrdersTextCard(
                name: "Notes",
                controller: ordersCreateController.txtNotes,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Amount",
                      keyboardType: TextInputType.number,
                      controller: ordersCreateController.txtAmount,
                    ),
                  ),
                  Expanded(
                    child: CommonOrdersTextCard(
                      name: "Bill Amount",
                      keyboardType: TextInputType.number,
                      controller: ordersCreateController.txtBillAmount,
                    ),
                  ),
                  CommonRequestAddressChips(
                    status: ordersCreateController.isPaymentMode != true ? "Credit" : "COD",
                    color: Colors.white,
                    backgroundColor: ordersCreateController.isPaymentMode != true ? Colors.blueAccent : Colors.green,
                    onTap: () => ordersCreateController.isPaymentMode != true ? ordersCreateController.onCredit() : ordersCreateController.onCash(),
                  ).paddingOnly(top: 5, right: 5),
                ],
              ),
              CommonOrdersTextCard(
                name: "lat-Long",
                controller: ordersCreateController.txtLatLng,
              ),
              commonButton(
                onTap: () => ordersCreateController.onCreateOrder(),
                text: "create order",
                height: 50.0,
              ).paddingOnly(left: 10, right: 10, top: 5),
            ],
          ),
        ),
      ),
    );
  }
}
