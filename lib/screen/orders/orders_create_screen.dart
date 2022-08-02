import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/orders_create_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:get/get.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);
  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  OrdersCreateController ordersCreateController = Get.put(OrdersCreateController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersCreateController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return ordersCreateController.willPopScope();
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
          body: RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const CommonOrdersTextCard(
                  name: "Name",
                  keyboardType: TextInputType.name,
                ),
                const CommonOrdersTextCard(
                  name: "Address",
                  keyboardType: TextInputType.streetAddress,
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
                        onSelect: (val, text) {
                          ordersCreateController.onRoutesSelected(val, text);
                        },
                      ),
                    );
                  },
                ),
                const CommonOrdersTextCard(
                  name: "Mobile",
                  keyboardType: TextInputType.number,
                ),
                const CommonOrdersTextCard(
                  name: "Bill No",
                ),
                Row(
                  children: const [
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Loose Pkg",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Box Pkg",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const CommonOrdersTextCard(
                  name: "Notes",
                ),
                Row(
                  children: const [
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Amount",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Bill Amount",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                CommonOrdersTextCard(
                  name: "lat-Long",
                  readOnly: true,
                  controller: ordersCreateController.txtLatitueLongitudeController,
                  suffixIcon: SizedBox(
                    height: 50,
                    width: 50,
                    child: Stack(
                      children: [
                        VerticalDivider(
                          thickness: 1.5,
                          indent: 7,
                          endIndent: 7,
                          width: 5,
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        IconButton(
                          icon: ordersCreateController.isLoading
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(),
                                )
                              : Icon(
                                  Icons.location_pin,
                                  color: Theme.of(context).primaryColor,
                                ),
                          onPressed: () => ordersCreateController.onTapLocation(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
