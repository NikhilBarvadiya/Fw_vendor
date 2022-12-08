// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_nodata.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/splash_controller.dart';
import 'package:fw_vendor/view/employe_view/controller/employe_home_controller.dart';
import 'package:fw_vendor/view/employe_view/screen/draft/drawer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmployeHomeScreen extends StatefulWidget {
  const EmployeHomeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeHomeScreen> createState() => _EmployeHomeScreenState();
}

class _EmployeHomeScreenState extends State<EmployeHomeScreen> {
  EmployeHomeController homeController = Get.put(EmployeHomeController());
  SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<EmployeHomeController>(
        builder: (_) => LoadingMode(
          isLoading: homeController.isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              foregroundColor: Colors.white,
              title: const Text("Drafts"),
              actions: [
                IconButton(onPressed: () => homeController.onScanner(), icon: const Icon(FontAwesomeIcons.qrcode)),
              ],
            ),
            drawer: DrawerView(
              isLoading: homeController.isLoading,
              name: "${homeController.employeUserData["name"]}",
              vendorName: "${homeController.employeUserData["vendorId"]["name"]}",
              mobile: homeController.employeUserData["mobile"],
              appVersion: splashController.appVersion,
              onPressed: () => homeController.onLogout(context),
            ),
            body: Column(
              children: [
                TabBar(
                  controller: homeController.tabController,
                  indicatorColor: homeController.isLoading ? Colors.grey : Theme.of(context).primaryColor,
                  onTap: (index) => homeController.onTapClick(index),
                  tabs: [
                    Tab(
                      child: Stack(
                        children: [
                          Center(child: Text("All", style: AppCss.h2.copyWith(fontWeight: FontWeight.w500, fontSize: 14)).paddingAll(5)),
                          homeController.allFilteredList.isNotEmpty
                              ? Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      homeController.allFilteredList.length.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 8),
                                      textAlign: TextAlign.center,
                                    ),
                                  ).paddingOnly(left: 30, bottom: 18),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Tab(
                      child: Stack(
                        children: [
                          Center(child: Text("Scanned by me", style: AppCss.h2.copyWith(fontWeight: FontWeight.w500, fontSize: 14)).paddingAll(5)),
                          homeController.myFilteredList.isNotEmpty
                              ? Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      homeController.myFilteredList.length.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 8),
                                      textAlign: TextAlign.center,
                                    ),
                                  ).paddingOnly(left: 125, bottom: 18),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: homeController.tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      homeController.allFilteredList.isNotEmpty
                          ? RefreshIndicator(
                              onRefresh: () => Future.sync(() => homeController.draftOrders("all")),
                              child: Column(
                                children: [
                                  homeController.isSearch ? _searchCard() : Container(),
                                  Expanded(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ...homeController.allFilteredList.map((a) {
                                          return _draftDataCard(a);
                                        }).toList(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!homeController.isLoading)
                                  Container(
                                    color: Colors.white,
                                    child: const NoDataWidget(
                                      title: "No data !",
                                      body: "No orders available",
                                    ),
                                  ),
                              ],
                            ),
                      homeController.myDraftList.isNotEmpty
                          ? RefreshIndicator(
                              onRefresh: () => Future.sync(() => homeController.draftOrders("my")),
                              child: Column(
                                children: [
                                  homeController.isSearch ? _searchCard() : Container(),
                                  Expanded(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ...homeController.myDraftList.map((a) {
                                          return _draftDataCard(a);
                                        }).toList(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!homeController.isLoading) const NoDataWidget(title: "No data !", body: "No orders available"),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: !homeController.isSearch
                ? FloatingActionButton(
                    onPressed: () => homeController.onSearchClick(),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.search),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  _searchCard() {
    return Container(
      padding: const EdgeInsets.only(right: 15, left: 10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(4), border: Border.all(color: Colors.blueGrey.withOpacity(0.8))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => homeController.runFilter(homeController.txtSearch.text),
            child: Icon(Icons.search_rounded, color: Colors.blueGrey.withOpacity(0.8), size: homeController.txtSearch.text != "" ? 15 : 20),
          ).paddingOnly(right: 5),
          Expanded(
            child: TextFormField(
              autofocus: false,
              controller: homeController.txtSearch,
              focusNode: homeController.txtSearchFocus,
              style: AppCss.body1,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(border: InputBorder.none, hintText: "Search by"),
              onChanged: (search) => homeController.runFilter(homeController.txtSearch.text),
              onEditingComplete: () => homeController.onEditingComplete(),
            ),
          ),
        ],
      ),
    );
  }

  _draftDataCard(item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        side: BorderSide(color: AppController().appTheme.secondary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppController().appTheme.secondary.withOpacity(0.6),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item["addressId"]["name"] != null && item["addressId"]["name"] != "") Text(item["addressId"]["name"], style: AppCss.h3),
                      Text(
                        DateFormat.yMMMd().add_jm().format(DateTime.parse(item['createdAt'])),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Bill No", style: AppCss.footnote.copyWith(fontSize: 12)).paddingOnly(right: 5),
                      Text(item["billNo"].toString(), style: AppCss.footnote),
                    ],
                  ).paddingAll(5),
                ),
              ],
            ).paddingOnly(left: 10, right: 10, top: 5, bottom: 5),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (item["addressId"]["person"] != null && item["addressId"]["person"] != "")
                    Text(
                      item["addressId"]["person"].toString().capitalizeFirst.toString(),
                      style: AppCss.poppins.copyWith(color: Colors.black),
                    ).paddingOnly(right: 5),
                  if (item["addressId"]["mobile"] != null && item["addressId"]["mobile"] != "")
                    Text("(${item["addressId"]["mobile"]})", style: AppCss.poppins.copyWith(color: Colors.black)),
                  const Spacer(),
                  if (item["employeeId"] != null && item["employeeId"] != "")
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      color: Colors.green,
                      child: Text("Scanned", style: AppCss.footnote.copyWith(color: Colors.white)).paddingOnly(right: 5, left: 5, top: 2, bottom: 2),
                    ),
                ],
              ),
              if (item["nOfPackages"] != null && item["nOfPackages"] != "" || item["nOfBoxes"] != null && item["nOfBoxes"] != "")
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("PKG", style: AppCss.footnote.copyWith(fontSize: 12)).paddingOnly(right: 5),
                    Text(item["nOfPackages"].toString(), style: AppCss.footnote).paddingOnly(right: 15),
                    Text("BOX", style: AppCss.footnote.copyWith(fontSize: 12)).paddingOnly(right: 5),
                    Text(item["nOfBoxes"].toString(), style: AppCss.footnote),
                  ],
                ),
              if (item["addressId"]["address"] != null && item["addressId"]["address"] != "")
                Text(item["addressId"]["address"].toString().capitalizeFirst.toString(), style: AppCss.caption),
              if (item["anyNote"] != null && item["anyNote"] != "")
                Row(
                  children: [
                    Icon(Icons.note_sharp, size: 15, color: Theme.of(context).primaryColor).paddingOnly(right: 5),
                    Text(item["anyNote"].toString().capitalizeFirst.toString(), style: AppCss.caption),
                  ],
                ),
              if (item["amount"] != null && item["amount"] != "" || item["cash"] != null && item["cash"] != "")
                Card(
                  elevation: 0.5,
                  margin: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("AMT", style: AppCss.footnote.copyWith(fontSize: 12, color: Colors.green)).paddingOnly(right: 5),
                      Text(item["amount"].toString(), style: AppCss.footnote.copyWith(color: Colors.green)),
                    ],
                  ).paddingAll(5),
                ).paddingOnly(top: 2),
            ],
          ).paddingAll(10),
        ],
      ),
    ).paddingAll(4);
  }
}
