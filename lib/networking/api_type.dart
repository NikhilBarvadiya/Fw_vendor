import 'package:fw_vendor/env.dart';var apiVersion = environment['serverConfig']['apiVersion'];class ApiMethods {  // Check app version  String appVersion(type) => "$apiVersion/application-information/$type";  final String login = "vendor/vendorSignIn";  final String offers = "v3/offers";  final String magicLink = "v3/login/magiclink/from/app";  final String magicLinkVerify = "v3/login/magiclink";  final String businessCategories = "site/manager/businessCategories";}