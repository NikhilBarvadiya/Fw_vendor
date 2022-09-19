import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/vendor_view/controller/draft_orders_controller.dart';
import 'package:get/get.dart';

class EditSelectedLocationScreen extends StatefulWidget {
  const EditSelectedLocationScreen({Key? key}) : super(key: key);
  @override
  State<EditSelectedLocationScreen> createState() => _EditSelectedLocationScreenState();
}

class _EditSelectedLocationScreenState extends State<EditSelectedLocationScreen> {
  DraftOrdersController draftOrdersController = Get.put(DraftOrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DraftOrdersController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          foregroundColor: Colors.white,
          title: const Text(
            "Edit Selected Location",
          ),
        ),
        body: LoadingMode(
          isLoading: draftOrdersController.isLoading,
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  CommonOrdersTextCard(
                    name: "Address Name",
                    controller: draftOrdersController.txtAddressName,
                    readOnly: true,
                  ),
                  CommonOrdersTextCard(
                    name: "Address",
                    keyboardType: TextInputType.streetAddress,
                    controller: draftOrdersController.txtAdress,
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonOrdersTextCard(
                          name: "Loose Pkg",
                          keyboardType: TextInputType.number,
                          controller: draftOrdersController.txtLoosePkg,
                        ),
                      ),
                      Expanded(
                        child: CommonOrdersTextCard(
                          name: "Box Pkg",
                          keyboardType: TextInputType.number,
                          controller: draftOrdersController.txtBoxPkg,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CommonOrdersTextCard(
                          name: "Bill No",
                          controller: draftOrdersController.txtBillNo,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: CommonOrdersTextCard(
                          name: "Bill Amount",
                          keyboardType: TextInputType.number,
                          controller: draftOrdersController.txtBillAmount,
                        ),
                      ),
                      Expanded(
                        child: CommonOrdersTextCard(
                          name: "Amount",
                          keyboardType: TextInputType.number,
                          controller: draftOrdersController.txtAmount,
                        ),
                      ),
                    ],
                  ),
                  CommonOrdersTextCard(
                    name: "Notes",
                    controller: draftOrdersController.txtNotes,
                    maxLines: 5,
                    minLines: 1,
                  ),
                ],
              ).paddingAll(10),
              Align(
                alignment: Alignment.bottomCenter,
                child: commonButton(
                  margin: EdgeInsets.zero,
                  borderRadius: 0.0,
                  onTap: () => draftOrdersController.onLocationUpdate(draftOrdersController.editData, context),
                  text: "Update",
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
