import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get.dart';

class CustomLocationCard extends StatelessWidget {
  final String? shopName;
  final String? personName;
  final String? mobileNumber;
  final String? address;
  final String? billAmount;
  final String? cash;
  final String? cashReceived;
  final String? status;
  final String? tickets;
  final String? driverName;
  final String? driverNote;
  final String? notes;
  final String? date;
  final void Function()? onPressed;
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
    this.onPressed,
    this.tickets,
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
                              : Colors.black,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).canvasColor,
      semanticContainer: true,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: status == "Pending"
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
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shopName != null)
            Text(shopName.toString().capitalizeFirst.toString(), style: AppCss.h3.copyWith(color: Colors.black, fontSize: 15)).paddingOnly(bottom: 5),
          Row(
            children: [
              if (personName != null && personName != "")
                Text(
                  personName ?? "",
                  style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                ).paddingOnly(right: 8),
              if (mobileNumber != null)
                Text(mobileNumber ?? "", style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ).paddingOnly(bottom: 5),
          if (address != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(address ?? "", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 12))),
                Text(date ?? "", style: AppCss.footnote.copyWith(color: Colors.black)).paddingOnly(left: 8),
              ],
            ).paddingOnly(bottom: 8),
          if (imageShow != null) Container(child: imageShow),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardWidget(context, "Bill Amount", billAmount ?? ""),
              _cardWidget(context, "Cash", cash ?? ""),
              _cardWidget(context, "Received Cash", cashReceived ?? ""),
              Chip(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: status == "Delivered" ? 1 : 0,
                backgroundColor: status == "Pending"
                    ? Colors.amber.shade500
                    : status == "Delivered"
                        ? Colors.white
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
                  style: AppCss.poppins.copyWith(color: status == "Delivered" ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (driverName != null && driverName != "")
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Driver name : ", style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                          Expanded(child: Text(driverName ?? "", style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12))),
                        ],
                      ).paddingOnly(top: 8, left: 2),
                    if (driverNote != null && driverNote != "")
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Driver notes : ", style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                          Expanded(child: Text(driverNote ?? "", style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12))),
                        ],
                      ).paddingOnly(left: 2, top: 5),
                    if (notes != null && notes != "")
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Notes : ", style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                          Expanded(child: Text(notes ?? "", style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12))),
                        ],
                      ).paddingOnly(left: 2, top: 5),
                  ],
                ),
              ),
              if (status == "Delivered")
                Align(
                  alignment: Alignment.topRight,
                  child: InputChip(
                    elevation: 1,
                    onPressed: onPressed,
                    shadowColor: Colors.deepOrange.shade500,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    backgroundColor: Colors.white,
                    label: Text(tickets ?? "", style: AppCss.poppins.copyWith(color: Colors.deepOrange.shade500, fontWeight: FontWeight.bold)),
                  ).paddingOnly(top: 5),
                ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 5, vertical: 8),
    );
  }

  Widget _cardWidget(context, String header, String amount) {
    return Card(
      elevation: 0.5,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            header,
            style: AppCss.caption.copyWith(fontWeight: FontWeight.bold, color: billAmount != "₹0.00" ? Colors.green : Colors.black),
          ).paddingOnly(bottom: 2),
          Text(amount, style: AppCss.caption.copyWith(fontWeight: FontWeight.bold)),
        ],
      ).paddingSymmetric(horizontal: 10, vertical: 4),
    );
  }
}
