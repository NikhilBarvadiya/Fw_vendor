// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/global_directory_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:get/get.dart';

class GlobalDirectoryDetailsScreen extends StatelessWidget {
  GlobalDirectoryDetailsScreen({Key? key}) : super(key: key);
  GlobalDirectoryController globalDirectoryController = Get.put(GlobalDirectoryController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalDirectoryController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          title: const Text(
            "Selected details",
            style: TextStyle(
              fontSize: 20,
            ),
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...globalDirectoryController.selectedOrderTrueList.map(
                    (e) {
                      return OrderAddressCard(
                        addressHeder: e["name"].toString(),
                        personName: e["person"].toString(),
                        mobileNumber: e["mobile"].toString(),
                        date: getFormattedDate(e["updatedAt"].toString()),
                        address: e["address"],
                        onTap: () {
                          globalDirectoryController.removeToSelectedList(e);
                        },
                        deleteIcon: Icons.clear,
                        deleteIconBoxColor: Colors.red,
                      );
                    },
                  ),
                ],
              ),
            ),
            commonButton(
              onTap: () => globalDirectoryController.onSaveLocation(),
              color: Colors.green,
              text: "Save location",
              height: 50.0,
            ),
          ],
        ).paddingAll(10),
      ),
    );
  }
}
