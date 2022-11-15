import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common_employe_widgets/custom_order_text_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/view/employe_view/controller/add_order_controller.dart';
import 'package:get/get.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({Key? key}) : super(key: key);

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  AddOrderController controller = Get.put(AddOrderController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddOrderController>(
      builder: (_) => LoadingMode(
        isLoading: controller.isLoading,
        child: Scaffold(
          appBar: AppBar(elevation: 1, foregroundColor: Colors.white, title: const Text("Add order")),
          body: Stack(
            children: [
              _addressCard(),
              Align(alignment: Alignment.bottomCenter, child: _addOrder()),
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
              commonTextField(
                labelText: "Address",
                controller: controller.txtAddress,
                focusNode: controller.txtAddressFocus,
                keyboardType: TextInputType.streetAddress,
                contentPadding: const EdgeInsets.only(left: 10, top: 10),
                maxLines: 6,
              ),
              commonTextField(
                labelText: "Mobile number",
                controller: controller.txtMobileNumber,
                focusNode: controller.txtMobileFocus,
                keyboardType: TextInputType.number,
              ),
            ],
          ).paddingAll(10)
        ],
      ).paddingAll(10),
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
          Text(controller.arguments["shopName"].toString(), textAlign: TextAlign.center, style: AppCss.h1.copyWith(fontSize: 25)),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(controller.arguments["partyCode"].toString(), textAlign: TextAlign.center, style: AppCss.caption.copyWith(fontSize: 12)),
          ).paddingAll(8),
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
                    Text(controller.arguments["billNo"].toString(), style: AppCss.footnote.copyWith(fontSize: 12)),
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
                    Text("₹ ${controller.arguments["amount"].toString()}", style: AppCss.footnote.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _addOrder() {
    return MaterialButton(
      textColor: Colors.white,
      minWidth: double.infinity,
      color: controller.isLoading ? AppController().appTheme.primary1.withOpacity(0.5) : AppController().appTheme.primary1,
      onPressed: () => controller.addOrderClick(),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Confirm", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
