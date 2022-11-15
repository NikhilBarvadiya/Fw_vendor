// ignore_for_file: must_be_immutable, unnecessary_null_comparison, unrelated_type_equality_checksimport 'package:flutter/material.dart';import 'package:fw_vendor/core/assets/index.dart';import 'package:fw_vendor/core/utilities/index.dart';import 'package:fw_vendor/view/auth_checking_view/controller/splash_controller.dart';import 'package:get/get.dart';class SplashScreen extends StatelessWidget {  SplashController splashController = Get.put(SplashController());  SplashScreen({Key? key}) : super(key: key);  @override  Widget build(BuildContext context) {    return GetBuilder<SplashController>(      builder: (_) => Scaffold(        body: Stack(          children: [            Image.asset(              imageAssets.splash,              height: appScreenUtil.screenHeight(MediaQuery.of(context).size.height),              width: appScreenUtil.screenWidth(MediaQuery.of(context).size.width),              fit: BoxFit.cover,            ),              Align(                alignment: Alignment.bottomCenter,                child: Container(                  margin: const EdgeInsets.only(bottom: 20),                  child: Text(                    "v${splashController.appVersion}",                    style: const TextStyle(                      color: Colors.grey,                      fontWeight: FontWeight.w500,                    ),                  ),                ),              ),          ],        ),      ),    );  }}