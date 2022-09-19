import 'package:get/get.dart';

class LocationController extends GetxController {
  dynamic status;
  String deliveredStatus = "";
  String shopName = "";
  @override
  void onInit() {
    status = Get.arguments;
    locationStatusData();
    super.onInit();
  }

  locationStatusData() {
    for (int i = 0; i < status.length; i++) {
      deliveredStatus = status[i]["status"].toString().capitalizeFirst.toString();
    }
  }
}
