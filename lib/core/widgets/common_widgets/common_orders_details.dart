// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonOrdersDetails extends StatelessWidget {
  final String? orderNo;
  final String? orderType;
  final String? locations;
  final String? date;
  final Widget? items;
  void Function()? locationClick;

  CommonOrdersDetails({
    Key? key,
    this.orderNo,
    this.orderType,
    this.locations,
    this.date,
    this.items,
    this.locationClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                orderNo ?? "",
                style: AppCss.h2,
              ).paddingOnly(right: 5),
              Text(
                orderType ?? "",
                style: AppCss.poppins,
              ),
              const Spacer(),
              TextButton(
                onPressed: locationClick,
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      locations ?? "",
                      style: AppCss.h3,
                    ).paddingOnly(right: 3),
                    const Text(
                      "Locations",
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            date ?? "",
            style: AppCss.footnote,
          ).paddingOnly(bottom: 10),
          Text(
            "Delivery report",
            style: AppCss.h3,
          ).paddingOnly(bottom: 10),
          Container(
            child: items,
          ),
        ],
      ),
    ).paddingOnly(bottom: 8);
  }
}
