import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/controller/draft_orders_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_draftOrders_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:get/get.dart';

class DraftOrderScreen extends StatefulWidget {
  const DraftOrderScreen({Key? key}) : super(key: key);

  @override
  State<DraftOrderScreen> createState() => _DraftOrderScreenState();
}

class _DraftOrderScreenState extends State<DraftOrderScreen> {
  DraftOrdersController draftOrdersController = Get.put(DraftOrdersController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DraftOrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return draftOrdersController.willPopScope();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: const Text("Your Draft Orders"),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                draftOrdersController.willPopScope();
              },
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ...draftOrdersController.getDraftOrderList.map(
                          (e) {
                            var index = draftOrdersController.getDraftOrderList.indexOf(e);
                            return Slidable(
                              key: ValueKey(index),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => draftOrdersController.onDeleteorders(e, context),
                                    backgroundColor: Colors.redAccent.shade100,
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) => draftOrdersController.addToSelectedList(e, context),
                                    backgroundColor: Colors.greenAccent.shade100,
                                    foregroundColor: Colors.green,
                                    icon: e['selected'] == null
                                        ? Icons.add
                                        : e['selected'] == true
                                            ? Icons.check
                                            : Icons.add,
                                    label: 'Add',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => draftOrdersController.onNotes(e, context),
                                    backgroundColor: Colors.deepOrangeAccent.shade100.withOpacity(0.5),
                                    foregroundColor: Colors.deepOrange,
                                    icon: FontAwesomeIcons.solidMessage,
                                    label: 'Notes',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) => draftOrdersController.onEdit(e),
                                    backgroundColor: Colors.blueAccent.shade100.withOpacity(0.5),
                                    foregroundColor: Colors.blue,
                                    icon: FontAwesomeIcons.expeditedssl,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                              child: CommonDraftOrdersCard(
                                name: e["addressId"]["name"] != null && e["addressId"]["name"] != "" ? e["addressId"]["name"].toString() : "",
                                address: e["addressId"]["address"] != null && e["addressId"]["address"] != "" ? e["addressId"]["address"].toString() : "",
                                billNumber: e["billNo"] != null && e["billNo"] != "" ? e["billNo"].toString() : "",
                                loose: e["nOfPackages"] != null && e["nOfPackages"] != "" ? e["nOfPackages"].toString() : "",
                                box: e["nOfBoxes"] != null && e["nOfBoxes"] != "" ? e["nOfBoxes"].toString() : "",
                                billAmount: e["amount"] != null && e["amount"] != "" ? e["amount"].toString() : "",
                                amount: e["cash"] != null && e["cash"] != "" ? e["cash"].toString() : "",
                                notes: e["anyNote"] != null && e["anyNote"] != "" ? e["anyNote"].toString() : "",
                                type: e["type"] != null && e["type"] != "" ? e["type"].toString().capitalizeFirst.toString() : "",
                                color: e['selected'] == true ? Colors.greenAccent[100] : Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (draftOrdersController.selectedOrderList.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: commonButton(
                        onTap: () => draftOrdersController.onProceed(draftOrdersController.selectedOrderList),
                        text: "Proceed Addresses (${draftOrdersController.selectedOrderList.length})",
                        height: 50.0,
                      ),
                    ),
                ],
              ).paddingAll(10),
              if (draftOrdersController.selectedOrderList.isEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    NoDataWidget(
                      title: "No data !",
                      body: "No orders available",
                    ),
                  ],
                ),
              if (draftOrdersController.isLoading)
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
