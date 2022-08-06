import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/show_address_book_controller.dart';
import 'package:fw_vendor/core/widgets/common/show_address_book_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
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
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return showAddressBookController.willPopScope();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text(
              "Address Book",
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showAddressBookController.onSearchButtonTapped();
                },
                icon: Icon(showAddressBookController.isSearch ? Icons.close : Icons.search),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(showAddressBookController.isSearch ? 50 : 0),
              child: showAddressBookController.isSearch
                  ? Container(
                      color: Colors.white,
                      child: CustomTextFormField(
                        container: showAddressBookController.txtSearch,
                        hintText: "Search".tr,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        padding: 15,
                        radius: 0,
                        maxLength: 10,
                        counterText: "",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {},
                      ),
                    )
                  : Container(),
            ),
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  if (showAddressBookController.getCustomerAddressList.isNotEmpty)
                    ...showAddressBookController.getCustomerAddressList.map(
                      (e) {
                        return ShowAddressBookCard(
                          name: e["name"].toString().capitalizeFirst.toString(),
                          mobileNumber: e["mobile"].toString(),
                          address: e["address"].toString().capitalizeFirst.toString(),
                          onDelete: () => showAddressBookController.onDeleteOrders(e["_id"]),
                          onAdd: () => showAddressBookController.onEdit(e),
                        );
                      },
                    ),
                ],
              ).paddingAll(5),
              if (showAddressBookController.getCustomerAddressList.isEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    NoDataWidget(
                      title: "Please add new orders!",
                      body: "No orders available",
                    ),
                  ],
                ),
              if (showAddressBookController.isLoading)
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
