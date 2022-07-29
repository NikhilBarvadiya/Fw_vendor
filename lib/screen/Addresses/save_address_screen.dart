// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/global_directory_controller.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:get/get.dart';

class SaveAddressScreen extends StatelessWidget {
  SaveAddressScreen({Key? key}) : super(key: key);
  GlobalDirectoryController globalDirectoryController = Get.put(GlobalDirectoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.white,
        title: const Text("Save Address"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ...globalDirectoryController.selectedOrderTrueList.map(
                  (e) {
                    return OrderAddressCard(
                      addressHeder: e["shopName"],
                      personName: e["personName"] + "\t\t\t(${e["number"]})",
                      address: e["address"],
                      area: e["area"],
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
        ],
      ),
    );
  }
}
