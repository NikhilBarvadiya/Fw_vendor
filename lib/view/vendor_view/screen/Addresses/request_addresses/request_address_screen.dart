import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/request_address_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/request_address_controller.dart';
import 'package:get/get.dart';

class RequestAddressScreen extends StatefulWidget {
  const RequestAddressScreen({Key? key}) : super(key: key);

  @override
  State<RequestAddressScreen> createState() => _RequestAddressScreenState();
}

class _RequestAddressScreenState extends State<RequestAddressScreen> {
  RequestAddressController requestAddressController = Get.put(RequestAddressController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestAddressController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return requestAddressController.willPopScope();
        },
        child: LoadingMode(
          isLoading: requestAddressController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Request address"),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => requestAddressController.willPopScope(),
              ),
              actions: [
                IconButton(
                  onPressed: () => requestAddressController.onSearchButtonTapped(),
                  icon: Container(
                    color: requestAddressController.isSearch ? Colors.redAccent : Theme.of(context).primaryColor,
                    child: Icon(
                      requestAddressController.isSearch ? Icons.close : Icons.search,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(requestAddressController.isSearch ? 50 : 0),
                child: requestAddressController.isSearch
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: requestAddressController.txtSearch,
                          focusNode: requestAddressController.txtSearchFocus,
                          hintText: "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: GestureDetector(
                            onTap: () => requestAddressController.onSearchAddress(),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blueGrey.withOpacity(0.8),
                              size: requestAddressController.txtSearch.text != "" ? 15 : 20,
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
                          onEditingComplete: () => requestAddressController.onSearchAddress(),
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    requestAddressController.onRefresh();
                  },
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: MediaQuery.of(context).size.height * 0.06,
                    ),
                    children: [
                      if (requestAddressController.vendorRequestAddressList.isNotEmpty)
                        ...requestAddressController.vendorRequestAddressList.map(
                          (e) {
                            return RequestAddressCard(
                              addressName: e["addressName"].toString(),
                              date: getFormattedDate(e["updatedAt"].toString()),
                              mobileNumber: e["mobile"].toString(),
                              address: e["address"].toString(),
                              type: e["isApprove"] == true ? "Approved" : "Pending",
                              onDeleteClick: () {
                                requestAddressController.onRequestAddressDelete(e["_id"], e);
                              },
                              onEditClick: () {
                                requestAddressController.onRequestAddressEdit(e);
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
                if (requestAddressController.vendorRequestAddressList.isEmpty && !requestAddressController.isLoading)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NoDataWidget(
                        title: "No data !",
                        body: "No orders available",
                      ),
                    ],
                  ),
              ],
            ).paddingAll(10),
          ),
        ),
      ),
    );
  }
}
