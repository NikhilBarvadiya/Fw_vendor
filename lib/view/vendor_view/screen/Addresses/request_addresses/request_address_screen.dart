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
  RequestAddressControler requestAddressControler = Get.put(RequestAddressControler());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestAddressControler>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return requestAddressControler.willPopScope();
        },
        child: LoadingMode(
          isLoading: requestAddressControler.isLoading,
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
                onPressed: () {
                  requestAddressControler.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    requestAddressControler.onSearchButtonTapped();
                  },
                  icon: Icon(requestAddressControler.isSearch ? Icons.close : Icons.search),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(requestAddressControler.isSearch ? 50 : 0),
                child: requestAddressControler.isSearch
                    ? Container(
                        color: Colors.white,
                        child: CustomTextFormField(
                          container: requestAddressControler.txtSearch,
                          focusNode: requestAddressControler.txtSearchFocus,
                          hintText: "Search".tr,
                          fillColor: Colors.white,
                          prefixIcon: GestureDetector(
                            onTap: () => requestAddressControler.onSearchAddress(),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blueGrey.withOpacity(0.8),
                              size: requestAddressControler.txtSearch.text != "" ? 15 : 20,
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
                          onEditingComplete: () => requestAddressControler.onSearchAddress(),
                        ),
                      )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    requestAddressControler.onRefresh();
                  },
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: MediaQuery.of(context).size.height * 0.06,
                    ),
                    children: [
                      if (requestAddressControler.vendorRequestAddressList.isNotEmpty)
                        ...requestAddressControler.vendorRequestAddressList.map(
                          (e) {
                            return RequestAddressCard(
                              addressName: e["addressName"].toString(),
                              date: getFormattedDate(e["updatedAt"].toString()),
                              mobileNumber: e["mobile"].toString(),
                              address: e["address"].toString(),
                              type: e["isApprove"] == true ? "Approved" : "Pending",
                              onDeleteClick: () {
                                requestAddressControler.onRequestAddressDelete(e["_id"], e);
                              },
                              onEditClick: () {
                                requestAddressControler.onRequestAddressEdit(e);
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
                if (requestAddressControler.vendorRequestAddressList.isEmpty)
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
