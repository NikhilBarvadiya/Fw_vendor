// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/common/common_note_card.dart';
import 'package:fw_vendor/core/widgets/common/common_package.dart';
import 'package:fw_vendor/core/widgets/common/custom_statistics_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/vendor_view/controller/dashboard_controller.dart';
import 'package:fw_vendor/view/vendor_view/controller/draft_orders_controller.dart';
import 'package:get/get.dart';

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({Key? key}) : super(key: key);
  DashboardController dashboardController = Get.put(DashboardController());
  final DraftOrdersController draftOrdersController = Get.isRegistered<DraftOrdersController>() ? Get.find() : Get.put(DraftOrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (_) {
        return LoadingMode(
          isLoading: dashboardController.isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (int i = 0; i < dashboardController.filters.length; i++)
                    CommonChips(
                      onTap: () => dashboardController.onChange(i),
                      color: dashboardController.filters[i]["isActive"] ? AppController().appTheme.primary.withOpacity(.8) : Colors.white,
                      text: dashboardController.filters[i]["label"].toString().capitalizeFirst,
                      textColor: dashboardController.filters[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                    ),
                  const Spacer(),
                  if (dashboardController.vendorgetPKGDetails != null && dashboardController.vendorgetPKGDetails["totalPkg"] != null)
                    CommonPackage(
                      packageLable: "PKGs",
                      count: dashboardController.vendorgetPKGDetails != null && dashboardController.vendorgetPKGDetails["totalPkg"] != ""
                          ? dashboardController.vendorgetPKGDetails["totalPkg"]
                          : "00",
                    ).paddingOnly(right: 5),
                  if (dashboardController.vendorgetPKGDetails != null && dashboardController.vendorgetPKGDetails["totalLocations"] != null)
                    CommonPackage(
                      packageLable: "ADDs",
                      count: dashboardController.vendorgetPKGDetails != null && dashboardController.vendorgetPKGDetails["totalLocations"] != ""
                          ? dashboardController.vendorgetPKGDetails["totalPkg"]
                          : "00",
                    ),
                ],
              ).paddingSymmetric(vertical: Get.height * 0.02),
              SizedBox(height: Get.height * 0.01),
              if (dashboardController.vendorRevenue != null)
                Row(
                  children: [
                    Expanded(
                      child: CustomStatisticsCard(
                        title: "Pending Orders",
                        count: dashboardController.vendorRevenue["pendingOrders"] != null
                            ? dashboardController.vendorRevenue["pendingOrders"].toString()
                            : "00",
                        onTap: () => dashboardController.onOrdersClick("pending"),
                        context: context,
                        color: Colors.blueGrey,
                        icon: Icons.pending_actions,
                      ),
                    ),
                    SizedBox(width: Get.width * 0.03),
                    Expanded(
                      child: CustomStatisticsCard(
                        title: "On Hold Orders",
                        count: dashboardController.vendorRevenue["runningOrders"] != null
                            ? dashboardController.vendorRevenue["runningOrders"].toString()
                            : "00",
                        onTap: () => dashboardController.onOrdersClick("running"),
                        context: context,
                        color: Colors.amber.shade500,
                        icon: Icons.running_with_errors,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: Get.height * 0.03),
              if (dashboardController.vendorRevenue != null)
                Row(
                  children: [
                    Expanded(
                      child: CustomStatisticsCard(
                        title: "Draft Orders",
                        count: draftOrdersController.getDraftOrderList.isNotEmpty ? draftOrdersController.getDraftOrderList.length.toString() : "00",
                        onTap: () => dashboardController.onDraftOrdersClick(),
                        context: context,
                        color: Colors.green.shade500,
                        icon: Icons.fact_check_outlined,
                      ),
                    ),
                    SizedBox(width: Get.width * 0.03),
                    Expanded(
                      child: CustomStatisticsCard(
                        title: "Tickets",
                        count: "00",
                        onTap: () => dashboardController.onComplaintClick(),
                        context: context,
                        color: Colors.blue.shade500,
                        icon: Icons.airplane_ticket,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: Get.height * 0.03),
              Expanded(
                child: CommonNoteCard(
                  note: dashboardController.bannersNote,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: Get.height * 0.01),
        );
      },
    );
  }
}
