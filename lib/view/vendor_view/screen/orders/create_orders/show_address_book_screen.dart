import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/show_address_book_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/view/vendor_view/controller/show_address_book_controller.dart';
import 'package:get/get.dart';

class ShowAddressBookScreen extends StatefulWidget {
  const ShowAddressBookScreen({Key? key}) : super(key: key);

  @override
  State<ShowAddressBookScreen> createState() => _ShowAddressBookScreenState();
}

class _ShowAddressBookScreenState extends State<ShowAddressBookScreen> {
  ShowAddressBookController showAddressBookController = Get.put(ShowAddressBookController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowAddressBookController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return showAddressBookController.willPopScope();
        },
        child: LoadingMode(
          isLoading: showAddressBookController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text(
                "Address Book",
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  showAddressBookController.willPopScope();
                },
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
                          focusNode: showAddressBookController.txtSearchFocus,
                          hintText: "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: GestureDetector(
                            onTap: () => showAddressBookController.onSearchAddress(),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blueGrey.withOpacity(0.8),
                              size: showAddressBookController.txtSearch.text != "" ? 15 : 20,
                            ),
                          ),
                          padding: 15,
                          radius: 0,
                          counterText: "",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                          onEditingComplete: () => showAddressBookController.onSearchAddress(),
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    showAddressBookController.onRefresh();
                  },
                  child: ListView(
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
                ),
                if (showAddressBookController.getCustomerAddressList.isEmpty&&!showAddressBookController.isLoading)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoDataWidget(
                        title: "Please add new orders!",
                        body: "No orders available",
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
