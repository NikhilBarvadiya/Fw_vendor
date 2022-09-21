import 'package:flutter/material.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/view/employe_view/screen/draft/employe_home.dart';
import 'package:fw_vendor/view/employe_view/screen/scanner/scanner_screen.dart';
import 'package:fw_vendor/view/employe_view/screen/scanner/verify_address.dart';
import 'package:fw_vendor/view/vendor_view/screen/Addresses/global_directory/global_directory_details_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/Addresses/global_directory/global_directory_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/Addresses/request_addresses/request_address_edit_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/Addresses/request_addresses/request_address_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/Addresses/save_addresses/save_address_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/chat/chat_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/create_orders/location_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/home/home_screen.dart';
import 'package:fw_vendor/view/auth_checking_view/app_update_screen.dart';
import 'package:fw_vendor/view/auth_checking_view/login_screen.dart';
import 'package:fw_vendor/view/auth_checking_view/splash_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/home/profile/profile_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/create_global_orders/create_global_orders_details_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/create_global_orders/create_global_orders_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/create_global_orders/place_orders_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/create_orders/orders_create_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/create_orders/orders_from_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/dashboard/orders_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/create_orders/show_address_book_screen.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/draft_orders/draft_orders.dart';
import 'package:fw_vendor/view/vendor_view/screen/orders/draft_orders/edit_selected_location.dart';
import 'package:fw_vendor/view/vendor_view/screen/settlement/bill_copy_settlement/bill_copy_settlement.dart';
import 'package:fw_vendor/view/vendor_view/screen/settlement/cash_settlement/cash_settlement.dart';
import 'package:fw_vendor/view/vendor_view/screen/settlement/return_settlement/return_order_settlement.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splash = "/";
  //Vendor....
  static String login = "/loginScreen";
  static String appUpdate = '/appUpdate';
  static String home = "/homeScreen";
  static String profileScreen = "/profileScreen";
  static String orders = "/orders";
  static String createOrders = "/createOrders";
  static String ordersFromScreen = "/ordersFromScreen";
  static String draftOrdersScreen = "/draftOrdersScreen";
  static String editSelectedLocationScreen = "/editSelectedLocationScreen";
  static String showAddressBookScreen = "/showAddressBookScreen";
  static String createGlobalOrdersScreen = "/createGlobalOrdersScreen";
  static String createGlobalOrdersDetailsScreen = "/createGlobalOrdersDetailsScreen";
  static String placeOrderScreen = "/placeOrderScreen";
  static String globalDirectoryScreen = "/globalDirectoryScreen";
  static String globalDirectoryDetailsScreen = "/globalDirectoryDetailsScreen";
  static String locationScreen = "/locationScreen";
  static String saveAddressScreen = "/saveAddressScreen";
  static String requestAddressScreen = "/requestAddressScreen";
  static String requestAddressEditScreen = "/requestAddressEditScreen";
  static String billCopySettlementScreen = "/billCopySettlementScreen";
  static String cashSettlementScreen = "/cashSettlementScreen";
  static String returnSettlementScreen = "/returnSettlementScreen";
  static String chatScreen = "/chatScreen";
  static String noInternet = "/noInternet";
  //Employe......
  static String employeHome = "/employeHome";
  static String verifyOrder = "/verifyOrder";
  static String scanner = "/scanner";


  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: appUpdate, page: () => const AppUpdateScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: orders, page: () => OrderScreen()),
    GetPage(name: createOrders, page: () => const CreateOrderScreen()),
    GetPage(name: ordersFromScreen, page: () => const OrdersFromScreen()),
    GetPage(name: draftOrdersScreen, page: () => const DraftOrderScreen()),
    GetPage(name: editSelectedLocationScreen, page: () => const EditSelectedLocationScreen()),
    GetPage(name: createGlobalOrdersScreen, page: () => const CreateGlobalOrdersScreen()),
    GetPage(name: createGlobalOrdersDetailsScreen, page: () => const CreateGlobalOrdersDetailsScreen()),
    GetPage(name: placeOrderScreen, page: () => const PlaceOrderScreen()),
    GetPage(name: globalDirectoryScreen, page: () => GlobalDirectoryScreen()),
    GetPage(name: globalDirectoryDetailsScreen, page: () => GlobalDirectoryDetailsScreen()),
    GetPage(name: locationScreen, page: () => LocationScreen()),
    GetPage(name: saveAddressScreen, page: () => SaveAddressScreen()),
    GetPage(name: showAddressBookScreen, page: () => const ShowAdrresBookScreen()),
    GetPage(name: requestAddressScreen, page: () => const RequestAddressScreen()),
    GetPage(name: requestAddressEditScreen, page: () => const RequestAddressEditScreen()),
    GetPage(name: billCopySettlementScreen, page: () => const BillCopySettementScreen()),
    GetPage(name: cashSettlementScreen, page: () => const CashSettlementScreen()),
    GetPage(name: returnSettlementScreen, page: () => const ReturnOrderSettlementScreen()),
    GetPage(name: chatScreen, page: () => const ChatScreen()),
    GetPage(
      name: noInternet,
      page: () => const Scaffold(
        body: Center(
          child: NoDataWidget(
            title: "No data !",
            body: "No internet found",
          ),
        ),
      ),
    ),
    GetPage(name: employeHome, page: () => const EmployeHomeScreen()),
    GetPage(name: verifyOrder, page: () => const VerifyOrderScreen()),
    GetPage(name: scanner, page: () => const ScannerScreen()),
  ];
}
