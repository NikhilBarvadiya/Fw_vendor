import 'package:fw_vendor/env.dart';

var apiVersion = environment['serverConfig']['apiVersion'];

class ApiMethods {
  // Check app version
  String appVersion(type) => "$apiVersion/application-information/$type";

  final String login = "vendor/vendorSignIn";
  final String changeShopOpenStatus = "vendor/changeShopOpenStatus";
  final String vendorWhoAmI = "vendor/whoAmI";
  final String vendorCheckProfile = "vendor/checkProfile";
  final String vendorGetRevenue = "vendor/getRevenue";
  final String vendorGetBanner = "vendor/getBanner";
  final String vendorgetPKGDetails = "vendor/getPKGDetails";
  final String vendorOrders = "vendor/orders";
}
