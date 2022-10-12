import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  dynamic status;

  @override
  void onInit() {
    status = Get.arguments;
    super.onInit();
  }

  resolvedOrders(location) {
    var arguments = {
      "location": location,
      "ordersDetails": status["ordersDetails"],
    };
    Get.toNamed(AppRoutes.ticketsScreen, arguments: arguments);
  }
}
