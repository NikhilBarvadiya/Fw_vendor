import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CustomLocationCard extends StatelessWidget {
  final String? shopName;
  final String? personName;
  final String? mobileNumber;
  final String? address;
  final String? billAmount;
  final String? cash;
  final String? cashReceived;
  final String? status;
  final String? driverName;
  final String? driverNote;
  final String? notes;
  final String? date;
  final dynamic imageShow;

  const CustomLocationCard({
    Key? key,
    this.shopName,
    this.personName,
    this.mobileNumber,
    this.address,
    this.billAmount,
    this.cash,
    this.cashReceived,
    this.status,
    this.imageShow,
    this.driverName,
    this.driverNote,
    this.notes,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: status == "Pending"
          ? Colors.amber.shade500
          : status == "Delivered"
              ? Colors.green.shade500
              : status == "Running"
                  ? Colors.blue.shade500
                  : status == "Cancelled"
                      ? Colors.deepOrange.shade500
                      : status == "Returned"
                          ? Colors.red.shade500
                          : status == "Completed"
                              ? Colors.blueGrey
                              : Colors.transparent,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).canvasColor,
      semanticContainer: true,
      margin: const EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shopName != null)
            Text(
              shopName ?? "",
              style: AppCss.h3.copyWith(
                color: Colors.black,
                fontSize: 15,
              ),
            ).paddingOnly(bottom: 5),
          Row(
            children: [
              if (personName != null && personName != "")
                Text(
                  personName ?? "",
                  style: AppCss.body1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ).paddingOnly(right: 8),
              if (mobileNumber != null)
                Text(
                  mobileNumber ?? "",
                  style: AppCss.body1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ).paddingOnly(bottom: 5),
          if (address != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    address ?? "",
                    style: AppCss.poppins.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  date ?? "",
                  style: AppCss.footnote.copyWith(
                    color: Colors.black,
                  ),
                ).paddingOnly(left: 8),
              ],
            ).paddingOnly(bottom: 8),
          if (imageShow != null)
            Container(
              child: imageShow,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardWidget(
                context,
                "Bill Amount",
                billAmount ?? "",
              ),
              _cardWidget(
                context,
                "Cash",
                cash ?? "",
              ),
              _cardWidget(
                context,
                "Received Cash",
                cashReceived ?? "",
              ),
              Chip(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                backgroundColor: status == "Pending"
                    ? Colors.amber.shade500
                    : status == "Delivered"
                        ? Colors.green.shade500
                        : status == "Running"
                            ? Colors.blue.shade500
                            : status == "Cancelled"
                                ? Colors.deepOrange.shade500
                                : status == "Returned"
                                    ? Colors.red.shade500
                                    : status == "Completed"
                                        ? Colors.grey
                                        : Colors.transparent,
                label: Text(
                  status ?? "",
                  style: AppCss.poppins.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          if (driverName != null && driverName != "")
            Row(
              children: [
                Text(
                  "Driver name : ",
                  style: AppCss.body1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  driverName ?? "",
                  style: AppCss.footnote.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).paddingOnly(top: 8, left: 2),
          if (driverNote != null && driverNote != "")
            Row(
              children: [
                Text(
                  "Driver notes : ",
                  style: AppCss.body1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  driverNote ?? "",
                  style: AppCss.body1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).paddingOnly(left: 2, top: 5),
          if (notes != null && notes != "")
            Row(
              children: [
                Text(
                  "Notes : ",
                  style: AppCss.body1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  notes ?? "",
                  style: AppCss.body1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).paddingOnly(left: 2, top: 5),
        ],
      ).paddingSymmetric(horizontal: 5, vertical: 8),
    );
  }

  Widget _cardWidget(context, String heder, String amount) {
    return Card(
      elevation: 1,
      shadowColor: status == "Pending"
          ? Colors.amber.shade500
          : status == "Delivered"
              ? Colors.green.shade500
              : status == "Running"
                  ? Colors.blue.shade500
                  : status == "Cancelled"
                      ? Colors.deepOrange.shade500
                      : status == "Returned"
                          ? Colors.red.shade500
                          : status == "Completed"
                              ? Colors.blueGrey
                              : Colors.transparent,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).canvasColor,
      semanticContainer: true,
      margin: const EdgeInsets.all(0),
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            heder,
            style: AppCss.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: billAmount != "₹0.00" ? Colors.green : Colors.black,
            ),
          ).paddingOnly(bottom: 2),
          Text(
            amount,
            style: AppCss.caption.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 10, vertical: 4),
    );
  }
}
