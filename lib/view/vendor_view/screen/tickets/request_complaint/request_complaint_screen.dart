import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/request_complaint_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_textformfield.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/request_complaint_controller.dart';
import 'package:get/get.dart';

class RequestComplaintScreen extends StatefulWidget {
  const RequestComplaintScreen({Key? key}) : super(key: key);

  @override
  State<RequestComplaintScreen> createState() => _RequestComplaintScreenState();
}

class _RequestComplaintScreenState extends State<RequestComplaintScreen> {
  RequestComplaintController controller = Get.put(RequestComplaintController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestComplaintController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return controller.willPopScope();
        },
        child: LoadingMode(
          isLoading: controller.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: const Text("Request Complaint"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  controller.willPopScope();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () => controller.onSearchButtonTapped(),
                  icon: Container(
                    color: controller.isSearch ? Colors.redAccent : Theme.of(context).primaryColor,
                    child: Icon(
                      controller.isSearch ? Icons.close : Icons.search,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(controller.isSearch ? 50 : 0),
                child: controller.isSearch
                    ? Container(
                  color: Colors.white,
                  child: CustomTextFormField(
                    container: controller.txtSearch,
                    focusNode: controller.txtSearchFocus,
                    hintText: "Search".tr,
                    fillColor: Colors.white,
                    prefixIcon: GestureDetector(
                      onTap: () => controller.onSearchAddress(),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.blueGrey.withOpacity(0.8),
                        size: controller.txtSearch.text != "" ? 15 : 20,
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
                    onEditingComplete: () => controller.onSearchAddress(),
                  ),
                )
                    : Container(),
              ),
            ),
            body: Stack(
              children: [
                ListView(
                  children: [
                    RequestComplaintCard(
                      addressName: "Shop name",
                      date: getFormattedDate(DateTime.now().toString()),
                      mobileNumber: "7016345790",
                      address: "address.............",
                      type: "Approved",
                      // "Pending",
                      onDeleteClick: () {
                        controller.onRequestAddressDelete("", "");
                      },
                      onEditClick: () {
                        controller.onRequestAddressEdit("");
                      },
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

