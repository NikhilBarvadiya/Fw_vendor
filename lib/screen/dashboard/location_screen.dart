// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/location_controller.dart';
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
            title: Text(locationController.deliveredStatus),
          ),
        );
      },
    );
  }
}
