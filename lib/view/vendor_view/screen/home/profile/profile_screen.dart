// ignore_for_file: deprecated_member_use
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/assets/index.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_chips.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/view/vendor_view/controller/profile_controller.dart';
import 'package:fw_vendor/view/vendor_view/screen/home/profile/timing_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'timing_add_edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return profileController.willPopScope();
        },
        child: DefaultTabController(
          length: 5,
          child: LoadingMode(
            isLoading: profileController.isLoading,
            child: Scaffold(
              appBar: AppBar(
                elevation: 1,
                automaticallyImplyLeading: true,
                foregroundColor: Colors.white,
                title: const Text("Profile"),
              ),
              body: Column(
                children: [
                  TabBar(
                      physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      isScrollable: true,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabs: tab()),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _account(),
                        _changePassword(),
                        _preparationTime(),
                        _shopAvailibillty(),
                        _gst(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  var tabList = [
    {"tab": "Account"},
    {"tab": "Change password"},
    {"tab": "Preparation Time"},
    {"tab": "Shop Availibility"},
    {"tab": "Gst"}
  ];

  List<Widget> tab() {
    return [
      for (int i = 0; i < tabList.length; i++)
        Tab(
          child: Text(
            tabList[i]["tab"].toString(),
            style: AppCss.h2.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
    ];
  }

  Widget _commonRow(
    String title,
    String txt,
    GestureRecognizer? recognizer,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: AppCss.h2.copyWith(
              color: Colors.black,
            ),
          ).paddingOnly(right: 13),
        ),
        RichText(
          text: TextSpan(
            text: ": $txt",
            style: AppCss.poppins.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: recognizer,
          ),
        ),
      ],
    ).paddingOnly(bottom: 10);
  }

  Widget _commonNewRow({
    required String title,
    required String txt,
    double? width,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title,
            style: AppCss.h2.copyWith(
              color: Colors.black,
            ),
          ).paddingOnly(right: 10),
        ),
        SizedBox(
          width: width ?? 0,
        ),
        Expanded(
          child: Text(
            ": $txt",
            style: AppCss.poppins.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 10);
  }

  Widget _account() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(imageAssets.avatar, width: profileController.isEdit ? 40 : 80, fit: BoxFit.fitWidth),
            CommonChips(
              text: "Edit",
              onTap: () => profileController.onEdit(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Theme.of(context).primaryColor,
              style: AppCss.h2.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ).paddingAll(10),
        if (profileController.isEdit != true)
          Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("PERSONAL INFO", style: AppCss.h1.copyWith(color: Colors.black)).paddingOnly(bottom: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text("Name", style: AppCss.h2.copyWith(color: Colors.black)),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  ": ${profileController.profileData["ownerName"].toString()}",
                                  style: AppCss.poppins.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                                ).paddingOnly(right: 5),
                                Text("[OWNER]", style: AppCss.h3.copyWith(color: Colors.black, letterSpacing: 1)),
                              ],
                            ),
                          ),
                        ],
                      ).paddingOnly(bottom: 10),
                      _commonRow(
                        "Email",
                        profileController.profileData["emailId"].toString(),
                        TapGestureRecognizer()
                          ..onTap = () async {
                            String link = "mailto:${profileController.profileData["emailId"].toString()}";
                            await launch(link);
                          },
                      ),
                      _commonRow(
                        "Mobile",
                        profileController.profileData["mobile"].toString(),
                        TapGestureRecognizer()
                          ..onTap = () async {
                            String link = "https://wa.me/${profileController.profileData["mobile"].toString()}";
                            await launch(link);
                          },
                      ),
                    ],
                  ).paddingOnly(top: 10, left: 10, right: 10),
                ).paddingOnly(bottom: 15),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("BUSINESS INFO", style: AppCss.h1.copyWith(color: Colors.black)).paddingOnly(bottom: 10),
                      _commonNewRow(
                        title: "Shop Name",
                        txt: profileController.profileData["name"].toString(),
                      ),
                      _commonNewRow(
                        title: "Business Category",
                        txt: profileController.profileData["businessType"].toString(),
                      ),
                      _commonNewRow(
                        title: "Address",
                        txt: profileController.profileData["address"]["address_line"].toString(),
                      ),
                      _commonNewRow(
                        title: "Account Status",
                        txt: profileController.profileData["isActive"] == true ? "Active" : "Not Active!",
                      ),
                    ],
                  ).paddingOnly(top: 10, left: 10, right: 10),
                ),
              ],
            ),
          ),
        if (profileController.isEdit != false)
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Shop Name",
                        controller: profileController.txtShopName,
                        focusNode: profileController.txtShopNameFocus,
                      ),
                    ),
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Name",
                        controller: profileController.txtName,
                        focusNode: profileController.txtNameFocus,
                      ),
                    ),
                  ],
                ),
                CommonOrdersTextCard(
                  name: "Email Id",
                  keyboardType: TextInputType.emailAddress,
                  controller: profileController.txtEmailId,
                  focusNode: profileController.txtEmailIdFocus,
                ),
                CommonOrdersTextCard(
                  name: "Address",
                  keyboardType: TextInputType.streetAddress,
                  controller: profileController.txtAddress,
                  focusNode: profileController.txtAddressFocus,
                  minLines: 1,
                  maxLines: 4,
                ),
                CommonOrdersTextCard(
                  name: "Area",
                  controller: profileController.txtArea,
                  focusNode: profileController.txtAreaFocus,
                ),
                CommonOrdersTextCard(
                  name: "PinCode",
                  controller: profileController.txtPinCode,
                  focusNode: profileController.txtPinCodeFocus,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Lat",
                        controller: profileController.txtLat,
                        focusNode: profileController.txtLatFocus,
                      ),
                    ),
                    Expanded(
                      child: CommonOrdersTextCard(
                        name: "Long",
                        controller: profileController.txtLong,
                        focusNode: profileController.txtLongFocus,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    commonButton(
                      onTap: () => profileController.onSave(context),
                      height: 50.0,
                      width: Get.width * 0.3,
                      color: Colors.green,
                      text: "Save",
                    ),
                    commonButton(
                      onTap: () => profileController.onCancel(context),
                      height: 50.0,
                      width: Get.width * 0.3,
                      color: Colors.red,
                      text: "Cancel",
                    ),
                  ],
                ).paddingSymmetric(vertical: 20, horizontal: 5),
              ],
            ),
          ),
      ],
    ).paddingAll(10);
  }

  Widget _preparationTime() {
    profileController.txtPreparationTime.text = profileController.profileData["prepTime"].toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonOrdersTextCard(
          name: "Time in minutes",
          controller: profileController.txtPreparationTime,
          focusNode: profileController.txtPreparationTimeFocus,
        ),
        const Spacer(),
        commonButton(
          onTap: () => profileController.onPreparationTime(context),
          color: Theme.of(context).primaryColor,
          text: "Submit",
        ).paddingOnly(left: 5),
      ],
    ).paddingAll(10);
  }

  Widget _shopAvailibillty() {
    return Stack(
      children: [
        profileController.shopAvailability.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  ...profileController.shopAvailability.map(
                    (e) {
                      return TimingBar(
                        onEdit: () {
                          _showSheet(true, e);
                        },
                        data: e,
                      );
                    },
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Outlet timings are empty!", style: TextStyle(fontWeight: FontWeight.w600)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [Text("Please tap on "), Icon(Icons.add, size: 18), Text(" icon")],
                    )
                  ],
                ),
              ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              _showSheet(false, null);
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ).paddingAll(10),
      ],
    );
  }

  _showSheet(bool isEdit, dynamic data) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return TimingAddEdit(
          isEdit: isEdit,
          data: data,
          upTimings: (timings, day) {
            if (isEdit == true) {
              profileController.updateTimings(data, timings, null, context);
            } else {
              profileController.updateTimings(null, timings, day, context);
            }
          },
        );
      },
    );
  }

  Widget _gst() {
    profileController.txtGst.text = profileController.profileData["gst"]["gstNumber"].toString();
    profileController.txtGSTCertificate.text = profileController.profileData["gst"]["gstBusinessName"].toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonOrdersTextCard(
          name: "GSTIN Number",
          controller: profileController.txtGst,
          readOnly: true,
        ),
        CommonOrdersTextCard(
          name: "Please Enter the GSTIN Number Again",
          controller: profileController.txtGst,
          readOnly: true,
        ),
        CommonOrdersTextCard(
          name: "Business/Legal name as per GST Certificate",
          controller: profileController.txtGSTCertificate,
          readOnly: true,
        ),
        const Spacer(),
        commonButton(
          onTap: () => profileController.onGst(context),
          color: Theme.of(context).primaryColor,
          text: "Submit",
        ).paddingOnly(left: 5),
      ],
    ).paddingAll(10);
  }

  Widget _changePassword() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonOrdersTextCard(
              name: "Current Password",
              controller: profileController.txtCurrentPassword,
              focusNode: profileController.txtCurrentPasswordFocus,
            ),
            CommonOrdersTextCard(
              name: "New Password",
              controller: profileController.txtNewPassword,
              focusNode: profileController.txtNewPasswordFocus,
            ),
            CommonOrdersTextCard(
              name: "Confirm Password",
              controller: profileController.txtConfirmPassword,
              focusNode: profileController.txtConfirmPasswordFocus,
            ),
            const Spacer(),
            commonButton(
              onTap: () => profileController.onChangePassword(),
              color: Theme.of(context).primaryColor,
              text: "Submit",
            ).paddingOnly(left: 5),
          ],
        ).paddingAll(10),
      ],
    );
  }
}
