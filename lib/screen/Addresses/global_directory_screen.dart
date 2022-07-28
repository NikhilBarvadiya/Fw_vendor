// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/controller/global_directory_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_vendor/core/widgets/common_widgets/common_button.dart';
import 'package:fw_vendor/core/widgets/common_widgets/order_address_card.dart';
import 'package:fw_vendor/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class GlobalDirectoryScreen extends StatelessWidget {
  GlobalDirectoryScreen({Key? key}) : super(key: key);
  GlobalDirectoryController globalDirectoryController = Get.put(GlobalDirectoryController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalDirectoryController>(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Global Directory",
                style: AppCss.h1,
              ),
              TextButton(
                onPressed: () {
                  globalDirectoryController.onSearch();
                  commonBottomSheet(
                    context: context,
                    height: MediaQuery.of(context).size.height * 0.6,
                    margin: 0.0,
                    widget: SearchableListView(
                      isLive: false,
                      isOnSearch: false,
                      isOnheder: false,
                      itemList: const [],
                      bindText: 'title',
                      bindValue: '_id',
                      labelText: 'Listing of global addresses.',
                      hintText: 'Please Select',
                      onSelect: (val, text) {},
                    ),
                  );
                },
                child: Icon(globalDirectoryController.isSearch != false ? Icons.arrow_drop_down : Icons.arrow_drop_up),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          if (globalDirectoryController.isSearch != false)
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: TextFormField(
                      onChanged: (search) {},
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Search',
                          hintText: 'Enter Order location',
                          border: InputBorder.none,
                          suffixIcon: SizedBox(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.search,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          hintStyle: const TextStyle(fontSize: 15),
                          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
                    ),
                  ).paddingOnly(bottom: 5),
                  ...globalDirectoryController.selectedAddress.map(
                    (e) {
                      return OrderAddressCard(
                        addressHeder: e["shopName"],
                        personName: e["personName"] + "\t\t\t(${e["number"]})",
                        address: e["address"],
                        onTap: () {
                          globalDirectoryController.addToSelectedList(e);
                        },
                        deleteIcon: e['selected'] == null
                            ? Icons.add
                            : e['selected'] == true
                                ? Icons.check
                                : Icons.add,
                        icon: e['selected'] == null
                            ? false
                            : e['selected'] == true
                                ? true
                                : false,
                        deleteIconColor: Colors.black,
                        deleteIconBoxColor: AppController().appTheme.green,
                        cardColors: e['selected'] == true ? Colors.green[100] : Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
          if (globalDirectoryController.isSearch != false)
            commonButton(
              onTap: () {
                globalDirectoryController.onSelectedLocation();
              },
              text: "Selected location (${globalDirectoryController.selectedOrderTrueList.length})",
              height: 50.0,
            ),
        ],
      ).paddingAll(10),
    );
  }
}