import 'package:flutter/material.dart';
import 'package:fw_vendor/screen/Addresses/global_directory/global_directory_details_screen.dart';
import 'package:fw_vendor/screen/Addresses/global_directory/global_directory_screen.dart';
import 'package:fw_vendor/screen/Addresses/request_addresses/request_address_screen.dart';
import 'package:fw_vendor/screen/Addresses/save_addresses/save_address_screen.dart';
import 'package:fw_vendor/screen/dashboard/location_screen.dart';
import 'package:fw_vendor/screen/orders/orders_create_screen.dart';
import 'package:fw_vendor/screen/orders/orders_screen.dart';
import 'package:fw_vendor/screen/home/home_screen.dart';
import 'package:fw_vendor/screen/login/login_screen.dart';
import 'package:fw_vendor/screen/login/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splash = "/";
  static String login = "/loginScreen";
  static String home = "/homeScreen";
  static String orders = "/orders";
  static String createOrders = "/createOrders";
  static String locationScreen = "/locationScreen";
  static String globalDirectoryScreen = "/globalDirectoryScreen";
  static String globalDirectoryDetailsScreen = "/globalDirectoryDetailsScreen";
  static String saveAddressScreen = "/saveAddressScreen";
  static String requestAddressScreen = "/requestAddressScreen";
  static String noInternet = "/noInternet";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: orders, page: () => OrderScreen()),
    GetPage(name: createOrders, page: () => const CreateOrderScreen()),
    GetPage(name: locationScreen, page: () => LocationScreen()),
    GetPage(name: globalDirectoryScreen, page: () => GlobalDirectoryScreen()),
    GetPage(name: globalDirectoryDetailsScreen, page: () => GlobalDirectoryDetailsScreen()),
    GetPage(name: saveAddressScreen, page: () => SaveAddressScreen()),
    GetPage(name: requestAddressScreen, page: () => const RequestAddressScreen()),
    GetPage(name: noInternet, page: () => const Center(child: Text("No internet found"))),
  ];
}
