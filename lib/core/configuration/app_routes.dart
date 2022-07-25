import 'package:flutter/material.dart';
import 'package:fw_vendor/screen/Addresses/global_directory_details_screen.dart';
import 'package:fw_vendor/screen/Addresses/save_address_screen.dart';
import 'package:fw_vendor/screen/home/home_screen.dart';
import 'package:fw_vendor/screen/login/login_screen.dart';
import 'package:fw_vendor/screen/login/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splash = "/";
  static String login = "/loginScreen";
  static String home = "/HomeScreen";
  static String globalDirectoryDetailsScreen = "/globalDirectoryDetailsScreen";
  static String saveAddressScreen = "/saveAddressScreen";
  static String noInternet = "/noInternet";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: globalDirectoryDetailsScreen, page: () => GlobalDirectoryDetailsScreen()),
    GetPage(name: saveAddressScreen, page: () => SaveAddressScreen()),
    GetPage(name: noInternet, page: () => const Center(child: Text("No internet found"))),
  ];
}
