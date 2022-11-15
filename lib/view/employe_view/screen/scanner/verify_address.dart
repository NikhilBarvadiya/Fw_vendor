import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_order_text_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/view/employe_view/controller/verify_order_controller.dart';
import 'package:get/get.dart';

class VerifyOrderScreen extends StatefulWidget {
  const VerifyOrderScreen({Key? key}) : super(key: key);

  @override
  State<VerifyOrderScreen> createState() => _VerifyOrderScreenState();
}

class _VerifyOrderScreenState extends State<VerifyOrderScreen> {
  VerifyOrderController controller = Get.put(VerifyOrderController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyOrderController>(
      builder: (_) => LoadingMode(
        isLoading: controller.isLoading,
        child: Scaffold(
          appBar: AppBar(elevation: 1, foregroundColor: Colors.white, title: const Text("Verify order")),
          body: Stack(
            children: [
              _addressCard(),
              Align(alignment: Alignment.bottomCenter, child: _draftOrder()),
            ],
          ),
        ),
      ),
    );
  }

  _addressCard() {
    return SizedBox(
      height: Get.height,
      child: ListView(
        children: [
          _textView(),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: commonTextField(
                      labelText: "PKG",
                      controller: controller.txtPKG,
                      focusNode: controller.txtPKGFocus,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: commonTextField(
                      labelText: "BOX",
                      controller: controller.txtBOX,
                      focusNode: controller.txtBOXFocus,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              commonTextField(
                labelText: "Note",
                controller: controller.txtNote,
                focusNode: controller.txtNoteFocus,
                height: 100.0,
              ),
            ],
          ).paddingOnly(left: 10, right: 10),
          const SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Text(
              controller.txtPersonName.text,
              textAlign: TextAlign.center,
              style: AppCss.h1.copyWith(color: Colors.black, fontSize: 30),
            ),
          ),
        ],
      ).paddingAll(10),
    );
  }

  _draftOrder() {
    return MaterialButton(
      textColor: Colors.white,
      minWidth: double.infinity,
      color: controller.isLoading ? AppController().appTheme.primary1.withOpacity(0.5) : AppController().appTheme.primary1,
      onPressed: () => controller.draftOrderClick(),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Confirm", style: TextStyle(fontSize: 18)),
      ),
    );
  }

  _textView() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 30),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(controller.txtShopName.text, textAlign: TextAlign.center, style: AppCss.h1.copyWith(fontSize: 25)),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              controller.arguments["shopName"]["partyCode"].toString(),
              textAlign: TextAlign.center,
              style: AppCss.caption.copyWith(fontSize: 12),
            ),
          ).paddingOnly(bottom: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(controller.txtAddress.text, textAlign: TextAlign.center, style: AppCss.poppins.copyWith(fontSize: 12)),
          ),
          const SizedBox(height: 5),
          Text(controller.txtMobileNumber.text, textAlign: TextAlign.center, style: AppCss.footnote.copyWith(fontSize: 14)),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Column(
                  children: [
                    Text("Bill No", style: AppCss.h2),
                    Text(controller.txtBillNumber.text, style: AppCss.footnote.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 100,
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Column(
                  children: [
                    Text("Amount", style: AppCss.h2),
                    Text("₹ ${controller.txtAmount.text}", style: AppCss.footnote.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
