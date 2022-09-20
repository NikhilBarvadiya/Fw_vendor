import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:get/get.dart';

class TypeController extends GetxController {
  vendorLogin() {
    Get.toNamed(AppRoutes.login);
  }

  employeLogin() {
    Get.toNamed(AppRoutes.employeLogin);
  }
}
