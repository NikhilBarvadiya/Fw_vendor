import 'package:fw_vendor/env.dart';

var apiVersion = environment['serverConfig']['apiVersion'];

class ApiMethods {
  // Check app version
  String appVersion(type) => "$apiVersion/application-information/$type";
  final String appVersions = "vendorEmployee/appVersion";
  final String login = "vendor/vendorSignIn";
  final String changeShopOpenStatus = "vendor/changeShopOpenStatus";
  final String vendorWhoAmI = "vendor/whoAmI";
  final String vendorCheckProfile = "vendor/checkProfile";
  final String vendorUpdateProfile = "vendor/updateProfile";
  final String vendorUpdatePreparationTime = "vendor/updatePreparationTime";
  final String vendorUpdateShopTimings = "vendor/updateShopTimings";
  final String vendorUpdatePassword = "vendor/updatePassword";
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
  final String vendorSetAddressRequest = "vendor/setAddressRequest";
  final String vendorDeleteRequestedAddress = "vendor/deleteRequestedAddress";
  final String getAllCustomerAddressName = "vendor/address/getAllCustomerAddressName";
  final String getCustomerAddressById = "vendor/address/getCustomerAddressById";
  final String saveShopOrder = "vendor/saveShopOrder";
  final String saveCustomerAddress = "vendor/address/saveCustomerAddress";
  final String getCustomerAddress = "vendor/address/getCustomerAddress";
  final String deleteCustomerAddress = "vendor/address/deleteCustomerAddress";
  final String vendorAddressesByArea = "vendor/vendorAddressesByArea";
  final String saveOrder = "vendor/saveOrder";
  final String codSettlement = "vendor/cod-settlement/getDetails";
  final String returnOrderSettlement = "vendor/vReturnOrder/Settlement/getData";
  final String getVendorDraftOrder = "vendor/get/vendorDraftOrder";
  final String updateVendorDraftOrder = "vendor/update/vendorDraftOrder";
  final String deleteVendorDraftOrder = "vendor/delete/vendorDraftOrders";
  final String getAllChats = "vendor/getAllChats";
  final String sendMessageToAdmin = "vendor/sendMessageToAdmin";
  final String setBillDetails = "vendor/vendorData/setBillDetails/get";

  final String setOrderTicket = "vendor/set/orderTicket"; //done...
  final String getOrderTicket = "vendor/get/orderTicket"; //done...
  final String updateOrderTicket = "vendor/update/orderTicket"; //done...
  final String getActivityOrderTicket = "vendor/getActivity/orderTicket"; //done...
  final String getOrderDetailsOrderTicket = "vendor/getOrderDetails/orderTicket"; //done...
  final String getReturnOrderDetails = "vendor/get/returnOrderDetails"; //done...
  final String statisticsOrderPackagesDetails = "vendor/statistics/orderPackagesDetails"; //done...

  final String employeLogin = "vendorEmployee/login";
  final String getDraftOrders = "vendorEmployee/getDraftOrders";
  final String verifyOrder = "vendorEmployee/getScanData/mappedAddress";
  final String draftOrder = "vendorEmployee/setScanData/draftOrder";
  final String addOrder = "vendorEmployee/setScanData/addOrder";
}
