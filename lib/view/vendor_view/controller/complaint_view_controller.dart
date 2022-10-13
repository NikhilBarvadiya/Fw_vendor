import 'package:fw_vendor/common/config.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/networking/index.dart';
import 'package:get/get.dart';

class ComplaintViewController extends GetxController {
  dynamic arguments;
  bool isLoading = false;

  @override
  void onInit() {
    arguments = Get.arguments;
    super.onInit();
  }

  clearRecording(e) {
    e["audioNote"] = "";
    update();
  }

  onStatusCheck(item) {
    informationDialog(
      title: "Do you reWant status!",
      onConfirm: () async {
        Get.back();
        await onStatusChange(item);
      },
    );
  }

  onStatusChange(item) async {
    try {
      isLoading = true;
      update();
      var status = item["status"] == "open"
          ? "resolved"
          : item["status"] == "resolved"
              ? "reopen"
              : "open";
      var request = {
        "vendorTicketId": item["_id"],
        "status": status,
      };
      var response = await apis.call(apiMethods.updateOrderTicket, request, ApiType.post);
      if (response.isSuccess == true) {
        successDialog(
          contentText: "${response.message.toString()}\n${item["status"] == "open" ? "Resolved" : item["status"] == "resolved" ? "Reopen" : "Open"}",
          onPressed: () async {
            Get.offNamedUntil(AppRoutes.complaintScreen, (route) => false);
          },
        );
        update();
      } else {
        warningDialog(
          contentText: response.message.toString(),
          onPressed: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      errorDialog(
        contentText: e.toString(),
        onPressed: () {
          Get.back();
        },
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }
}
