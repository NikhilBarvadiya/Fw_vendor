import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:get/get.dart';

class BillCopySettlementController extends GetxController {
  willPopScope() {
    Get.offNamed(AppRoutes.home);
  }
}
