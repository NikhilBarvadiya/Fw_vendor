// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_location_card.dart';
import 'package:fw_vendor/env.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/location_controller.dart';
import 'package:get/get.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({Key? key}) : super(key: key);
  LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text(
              "Location Detail",
            ),
          ),
          body: ListView(
            children: [
              ...locationController.status.map(
                (e) {
                  return CustomLocationCard(
                    shopName: e["addressId"] != null
                        ? e["addressId"]["name"].toString()
                        : e["name"] != null
                            ? e["name"].toString()
                            : "",
                    personName: e["addressId"] != null
                        ? e["addressId"]["person"].toString()
                        : e["person"] != null
                            ? e["person"].toString()
                            : "",
                    mobileNumber: e["addressId"] != null
                        ? e["addressId"]["mobile"].toString()
                        : e["mobile"] != null
                            ? e["mobile"].toString()
                            : "",
                    address: e["addressId"] != null
                        ? e["addressId"]["address"].toString().capitalizeFirst
                        : e["address"] != null
                            ? e["address"].toString().capitalizeFirst
                            : "",
                    billAmount: e["amount"] != "" && e["amount"] != null && e["amount"] != 0 ? "₹${e["amount"]}" : "₹0.00",
                    cash: e["cash"] != "" && e["cash"] != null && e["cash"] != 0 ? "₹${e["cash"]}" : "₹0.00",
                    cashReceived: e["cashReceived"] != "" && e["cashReceived"] != null && e["cashReceived"] != 0 ? "₹${e["cashReceived"]}" : "₹0.00",
                    status: e["status"].toString().capitalizeFirst,
                    driverName: e["driverId"] != null ? e["driverId"]["name"].toString() : "",
                    driverNote: e["driverNotes"] != null ? e["driverNotes"].toString().capitalizeFirst : "",
                    notes: e["notes"] != null ? e["notes"].toString().capitalizeFirst : "",
                    date: e["updatedAt"] != "" ? getFormattedDate(e["updatedAt"].toString()) : "",
                    imageShow: e["images"] != null
                        ? Wrap(
                            children: [
                              for (int i = 0; i < e["images"].length; i++)
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      builder: (BuildContext context) => AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.all(2),
                                        title: Container(
                                          decoration: const BoxDecoration(),
                                          height: MediaQuery.of(context).size.height / 2,
                                          width: MediaQuery.of(context).size.width,
                                          child: Image.network(
                                            environment["imagesbaseUrl"] + e["images"][i].replaceAll("//", "/").toString(),
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      context: context,
                                    );
                                  },
                                  child: Image.network(
                                    environment["imagesbaseUrl"] + e["images"][i].replaceAll("//", "/").toString(),
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.scaleDown,
                                    cacheHeight: 65,
                                    cacheWidth: 60,
                                  ).paddingOnly(left: 10, bottom: 10),
                                ),
                            ],
                          )
                        : null,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
