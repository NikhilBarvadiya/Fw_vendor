import 'package:flutter/material.dart';
import 'package:fw_vendor/common_controller/app_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/create_global_orders_controller.dart';
import 'package:get/get.dart';

class CreateGlobalOrdersDetailsScreen extends StatefulWidget {
  const CreateGlobalOrdersDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CreateGlobalOrdersDetailsScreen> createState() => _CreateGlobalOrdersDetailsScreenState();
}

class _CreateGlobalOrdersDetailsScreenState extends State<CreateGlobalOrdersDetailsScreen> {
  CreateGlobalOrdersCntroller createGlobalOrdersCntroller = Get.put(CreateGlobalOrdersCntroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateGlobalOrdersCntroller>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          title: const Text(
            "Selected Addresses",
            style: TextStyle(
              fontSize: 20,
            ),
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
        ),
        body: Stack(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.of(context).size.height * 0.06,
                ),
                children: [
                  if (createGlobalOrdersCntroller.selectedOrderTrueList.isNotEmpty)
                    ...createGlobalOrdersCntroller.selectedOrderTrueList.map(
                      (e) {
                        return OrderAddressCard(
                          addressHeder: e["globalAddressId"]["name"].toString(),
                          personName: e["globalAddressId"]["person"].toString(),
                          mobileNumber: e["globalAddressId"]["mobile"].toString(),
                          date: getFormattedDate(e["globalAddressId"]["updatedAt"].toString()),
                          address: e["globalAddressId"]["address"],
                          onTap: () {
                            createGlobalOrdersCntroller.removeToSelectedList(e);
                          },
                          icon: true,
                          cardColors: Colors.white,
                        );
                      },
                    ),
                ],
              ).paddingAll(10),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: commonButton(
                margin: EdgeInsets.zero,
                borderRadius: 0.0,
                color: createGlobalOrdersCntroller.selectedOrderTrueList.isNotEmpty ? AppController().appTheme.primary1 : Colors.grey,
                onTap: () => createGlobalOrdersCntroller.onProceed(createGlobalOrdersCntroller.selectedOrderTrueList),
                text: "Proceed",
                height: 50.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
