import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common/searchable_list.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/vendor_view/controller/request_complaint_edit_controller.dart';
import 'package:get/get.dart';

class RequestComplaintEditScreen extends StatefulWidget {
  const RequestComplaintEditScreen({Key? key}) : super(key: key);

  @override
  State<RequestComplaintEditScreen> createState() => _RequestComplaintEditScreenState();
}

class _RequestComplaintEditScreenState extends State<RequestComplaintEditScreen> {
  RequestComplaintEditController controller = Get.put(RequestComplaintEditController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestComplaintEditController>(
      builder: (_) => LoadingMode(
        isLoading: controller.isLoading,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text("Request edit Complaint"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  CommonOrdersTextCard(
                    name: "Routes",
                    hintText: controller.routesSelected != "" ? controller.routesSelected.capitalizeFirst.toString() : "",
                    readOnly: true,
                    suffixIcon: controller.routesSelected != "" ? null : const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      commonBottomSheet(
                        context: context,
                        height: MediaQuery.of(context).size.height * 0.6,
                        widget: SearchableListView(
                          isLive: false,
                          isOnSearch: false,
                          isOnheder: true,
                          isDivider: false,
                          hederColor: Theme.of(context).primaryColor,
                          hederTxtColor: Colors.white,
                          itemList: controller.vendorRoutesList,
                          hederText: "Routes",
                          bindText: 'name',
                          bindValue: '_id',
                          labelText: 'Listing of global addresses.',
                          hintText: 'Please Select',
                          onSelect: (val, text, e) {
                            // requestAddressEditController.selectedRoutes(val, text);
                          },
                        ),
                      );
                    },
                  ),
                  CommonOrdersTextCard(name: "Business Name", controller: controller.txtName, focusNode: controller.txtNameFocus),
                  CommonOrdersTextCard(
                      name: "Mobile", controller: controller.txtMobile, focusNode: controller.txtMobileFocus, keyboardType: TextInputType.number),
                  CommonOrdersTextCard(
                      name: "lat-Long", controller: controller.txtLatLng, focusNode: controller.txtLatLngFocus, keyboardType: TextInputType.number),
                  CommonOrdersTextCard(name: "Plus Code", controller: controller.txtPlusCode, focusNode: controller.txtPlusFocus),
                  CommonOrdersTextCard(
                    name: "Address",
                    keyboardType: TextInputType.streetAddress,
                    controller: controller.txtAddress,
                    focusNode: controller.txtAddressFocus,
                    minLines: 1,
                    maxLines: 4,
                  ),
                  Row(
                    children: [
                      commonButton(
                          onTap: () => controller.onSubmit(context), height: 50.0, width: Get.width * 0.3, color: Colors.green, text: "Submit"),
                      commonButton(onTap: () => controller.screenFocus(), height: 50.0, width: Get.width * 0.3, color: Colors.red, text: "Clear"),
                    ],
                  ).paddingSymmetric(vertical: 20, horizontal: 5),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
