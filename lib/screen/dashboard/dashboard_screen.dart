// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/dashboard_controller.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/common/common_note_card.dart';
import 'package:fw_vendor/core/widgets/common/common_package.dart';
import 'package:fw_vendor/core/widgets/common/custom_statistics_card.dart';
import 'package:get/get.dart';

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({Key? key}) : super(key: key);
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (_) {
        return Column(
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
                    count: dashboardController.vendorgetPKGDetails != null && dashboardController.vendorgetPKGDetails["totalPkg"] != "" ? dashboardController.vendorgetPKGDetails["totalPkg"] : "00",
                  ).paddingOnly(right: 5),
                if (dashboardController.vendorgetPKGDetails != null && dashboardController.vendorgetPKGDetails["totalLocations"] != null)
                  CommonPackage(
                    packageLable: "ADDs",
                    count: dashboardController.vendorgetPKGDetails != null && dashboardController.vendorgetPKGDetails["totalLocations"] != "" ? dashboardController.vendorgetPKGDetails["totalPkg"] : "00",
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
                      count: dashboardController.vendorRevenue["pendingOrders"] != null ? dashboardController.vendorRevenue["pendingOrders"].toString() : "00",
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
                      count: dashboardController.vendorRevenue["runningOrders"] != null ? dashboardController.vendorRevenue["runningOrders"].toString() : "00",
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
                      title: "Completed Orders",
                      count: "00",
                      onTap: () => dashboardController.onOrdersClick("completed"),
                      context: context,
                      color: Colors.green.shade500,
                      icon: Icons.fact_check_outlined,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.03),
                  Expanded(
                    child: CustomStatisticsCard(
                      title: "Cancelled Orders",
                      count: dashboardController.vendorRevenue["cancelledOrders"] != null ? dashboardController.vendorRevenue["cancelledOrders"].toString() : "00",
                      onTap: () => dashboardController.onOrdersClick("cancelled"),
                      context: context,
                      color: Colors.red.shade500,
                      icon: Icons.cancel,
                    ),
                  ),
                ],
              ),
            SizedBox(height: Get.height * 0.03),
            Expanded(
              child: CommonNoteCard(
                note: dashboardController.bannersNote,
              ),
            )
          ],
        ).paddingSymmetric(horizontal: Get.height * 0.01);
      },
    );
  }
}
