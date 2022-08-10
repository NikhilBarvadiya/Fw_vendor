import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/place_orders_controller.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/place_orders_card.dart';
import 'package:get/get.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  PlaceOrdersController placeOrdersController = Get.put(PlaceOrdersController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlaceOrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return placeOrdersController.willPopScope();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Total Address",
                ).paddingOnly(right: 10),
                Card(
                  child: Text(
                    "${placeOrdersController.selectedOrderList.length}",
                    style: AppCss.footnote.copyWith(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ).paddingSymmetric(horizontal: 10, vertical: 5),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        if (placeOrdersController.selectedOrderList.isNotEmpty)
                          ...placeOrdersController.selectedOrderList.map(
                            (e) {
                              var index = placeOrdersController.selectedOrderList.indexOf(e);
                              return PlaceOrdersCard(
                                name: e["globalAddressId"] != null && e["globalAddressId"]["name"] != ""
                                    ? e["globalAddressId"]["name"].toString()
                                    : e["addressId"]["name"] != null && e["addressId"]["name"] != ""
                                        ? e["addressId"]["name"].toString()
                                        : "",
                                person: e["globalAddressId"] != null && e["globalAddressId"]["person"] != ""
                                    ? e["globalAddressId"]["person"].toString()
                                    : e["addressId"]["person"] != null && e["addressId"]["person"] != ""
                                        ? e["addressId"]["person"].toString()
                                        : "",
                                mobile: e["globalAddressId"] != null && e["globalAddressId"]["mobile"] != ""
                                    ? e["globalAddressId"]["mobile"].toString()
                                    : e["addressId"]["mobile"] != null && e["addressId"]["mobile"] != ""
                                        ? e["addressId"]["mobile"].toString()
                                        : "",
                                address: e["globalAddressId"] != null && e["globalAddressId"]["address"] != ""
                                    ? e["globalAddressId"]["address"].toString()
                                    : e["addressId"]["address"] != null && e["addressId"]["address"] != ""
                                        ? e["addressId"]["address"].toString()
                                        : "",
                                billNo: placeOrdersController.edit.isNotEmpty && placeOrdersController.edit.length > index && placeOrdersController.edit[index]["_id"] == index
                                    ? placeOrdersController.edit[index]["billNo"].toString()
                                    : e["billNo"] != null && e["billNo"] != ""
                                        ? e["billNo"].toString()
                                        : "",
                                type: placeOrdersController.edit.isNotEmpty && placeOrdersController.edit.length > index && placeOrdersController.edit[index]["_id"] == index
                                    ? placeOrdersController.edit[index]["paymentMethod"].toString()
                                    : e["type"] != null && e["type"] != ""
                                        ? e["type"].toString().capitalizeFirst.toString()
                                        : "credit",
                                amount: placeOrdersController.edit.isNotEmpty && placeOrdersController.edit.length > index && placeOrdersController.edit[index]["_id"] == index
                                    ? placeOrdersController.edit[index]["amount"].toString()
                                    : e["cash"] != null && e["cash"] != ""
                                        ? e["cash"].toString()
                                        : "0",
                                billAmount: placeOrdersController.edit.isNotEmpty && placeOrdersController.edit.length > index && placeOrdersController.edit[index]["_id"] == index
                                    ? placeOrdersController.edit[index]["cash"].toString()
                                    : e["amount"] != null && e["amount"] != ""
                                        ? e["amount"].toString()
                                        : "0",
                                notes: placeOrdersController.edit.isNotEmpty && placeOrdersController.edit.length > index && placeOrdersController.edit[index]["_id"] == index
                                    ? placeOrdersController.edit[index]["notes"].toString()
                                    : e["anyNote"] != null && e["anyNote"] != ""
                                        ? e["anyNote"].toString()
                                        : "___",
                                loose: placeOrdersController.edit.isNotEmpty && placeOrdersController.edit.length > index && placeOrdersController.edit[index]["_id"] == index
                                    ? placeOrdersController.edit[index]["nOfPackages"].toString()
                                    : e["nOfPackages"] != null && e["nOfPackages"] != ""
                                        ? e["nOfPackages"].toString()
                                        : "0",
                                box: placeOrdersController.edit.isNotEmpty && placeOrdersController.edit.length > index && placeOrdersController.edit[index]["_id"] == index
                                    ? placeOrdersController.edit[index]["nOfBoxes"].toString()
                                    : e["nOfBoxes"] != null && e["nOfBoxes"] != ""
                                        ? e["nOfBoxes"].toString()
                                        : "0",
                                onTap: () => placeOrdersController.onEdit(context, index),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  commonButton(
                    onTap: () => placeOrdersController.onPlaceOrder(placeOrdersController.selectedOrderList, context),
                    color: Colors.green,
                    text: "Place orders",
                    height: 50.0,
                  ),
                ],
              ).paddingAll(10),
              if (placeOrdersController.isLoading)
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
