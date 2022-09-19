import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/create_orders_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/view/vendor_view/controller/orders_create_controller.dart';
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
        child: LoadingMode(
          isLoading: ordersCreateController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text(
                "Orders view",
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  ordersCreateController.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ordersCreateController.onAdd();
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ordersCreateController.onShowAddressBook();
                  },
                  icon: const Icon(
                    Icons.book,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.06,
                  ),
                  children: [
                    if (ordersCreateController.createList.isNotEmpty)
                      ...ordersCreateController.createList.map(
                        (e) {
                          return CreateOrdersCard(
                            name: e["name"].toString().capitalizeFirst.toString(),
                            billNo: e["billNo"].toString(),
                            mobileNumber: e["mobile"].toString(),
                            address: e["address"].toString()..capitalizeFirst.toString(),
                            area: e["routeName"].toString().capitalizeFirst.toString(),
                            amount: e["cash"].toString(),
                            billAmount: e["amount"].toString(),
                            type: e["paymentMethod"].toString().capitalizeFirst.toString(),
                            onTap: () => ordersCreateController.onRemoveOrders(e),
                          );
                        },
                      )
                  ],
                ).paddingAll(10),
                if (ordersCreateController.createList.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: commonButton(
                      margin: EdgeInsets.zero,
                      borderRadius: 0.0,
                      onTap: () => ordersCreateController.onProceedOrder(context),
                      text: "Proceed order",
                      height: 50.0,
                    ),
                  ),
                if (ordersCreateController.createList.isEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoDataWidget(
                        title: "Please add new orders!",
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
