import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/orders_create_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/create_orders_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
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
              "Orders view",
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
                  ordersCreateController.onShowAdrresBook();
                },
                icon: const Icon(
                  Icons.book,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
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
                    ),
                  ),
                  if (ordersCreateController.createList.isNotEmpty)
                    commonButton(
                      onTap: () => ordersCreateController.onProceedOrder(context),
                      text: "Proceed order",
                      height: 50.0,
                    ).paddingOnly(left: 10, right: 10, top: 5, bottom: 5),
                ],
              ).paddingAll(10),
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
              if (ordersCreateController.isLoading)
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
