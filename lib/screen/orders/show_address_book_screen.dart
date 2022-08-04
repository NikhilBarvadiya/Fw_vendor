import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/show_address_book_controller.dart';
import 'package:fw_vendor/core/widgets/common/show_address_book_card.dart';
import 'package:get/get.dart';

class ShowAdrresBookScreen extends StatefulWidget {
  const ShowAdrresBookScreen({Key? key}) : super(key: key);

  @override
  State<ShowAdrresBookScreen> createState() => _ShowAdrresBookScreenState();
}

class _ShowAdrresBookScreenState extends State<ShowAdrresBookScreen> {
  ShowAddressBookController showAddressBookController = Get.put(ShowAddressBookController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowAddressBookController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          title: const Text(
            "Address Book",
          ),
        ),
        body: ListView(
          children: [
            ...showAddressBookController.getCustomerAddressList.map(
              (e) {
                return ShowAddressBookCard(
                  name: e["name"].toString().capitalizeFirst.toString(),
                  mobileNumber: e["mobile"].toString(),
                  address: e["address"].toString().capitalizeFirst.toString(),
                );
              },
            ),
          ],
        ).paddingAll(5),
      ),
    );
  }
}
