import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/request_address_controller.dart';
import 'package:fw_vendor/core/widgets/common/request_address_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
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
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text("Request address"),
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
                        onEditClick: () {},
                      );
                    },
                  ),
                ],
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
              if (requestAddressControler.isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(.8),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ).paddingAll(10),
        ),
      ),
    );
  }
}
