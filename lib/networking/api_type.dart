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
  final String vendorAreas = "vendor/areas";
  final String vendorGlobalAddresses = "vendor/globalAddresses";
  final String vendorRoutes = "vendor/vendorRoutes";
  final String vendorsaveAddress = "vendor/saveAddress";
  final String vendorAddresses = "vendor/vendorAddresses";
  final String vendorDeleteAddress = "vendor/deleteAddress";
  final String vendorMappedAddress = "vendor/getMappedAddress";
  final String vendorRemoveMappedAddress = "vendor/removeMappedAddress";
  final String vendorToggleCreditCash = "vendor/toggleCreditCash";
  final String vendorRequestedAddress = "vendor/getRequestedAddress";
  final String vendordeleteRequestedAddress = "vendor/deleteRequestedAddress";
}
