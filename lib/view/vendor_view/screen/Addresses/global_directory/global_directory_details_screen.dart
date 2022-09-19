// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/global_directory_controller.dart';
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
            "Selected Addresses",
            style: TextStyle(
              fontSize: 20,
            ),
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
        ),
        body: LoadingMode(
          isLoading: globalDirectoryController.isLoading,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: MediaQuery.of(context).size.height * 0.06,
                      ),
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
                              icon: true,
                              cardColors: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingAll(10),
              Align(
                alignment: Alignment.bottomCenter,
                child: commonButton(
                  margin: EdgeInsets.zero,
                  borderRadius: 0.0,
                  onTap: () => globalDirectoryController.onSaveLocation(context),
                  color: Colors.green,
                  text: "Save location",
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
