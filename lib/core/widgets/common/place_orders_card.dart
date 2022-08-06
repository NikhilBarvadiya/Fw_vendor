import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get.dart';

class PlaceOrdersCard extends StatefulWidget {
  final String? name;
  final String? person;
  final String? mobile;
  final String? billNo;
  final String? type;
  final String? address;
  final String? amount;
  final String? billAmount;
  final String? notes;
  final String? loose;
  final String? box;
  final void Function()? onTap;

  const PlaceOrdersCard({
    Key? key,
    this.name,
    this.person,
    this.mobile,
    this.billNo,
    this.type,
    this.address,
    this.amount,
    this.billAmount,
    this.notes,
    this.loose,
    this.box,
    this.onTap,
  }) : super(key: key);

  @override
  State<PlaceOrdersCard> createState() => _PlaceOrdersCardState();
}

class _PlaceOrdersCardState extends State<PlaceOrdersCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).canvasColor,
      semanticContainer: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.name != null && widget.name != "")
                Expanded(
                  child: Text(
                    widget.name ?? "",
                    style: AppCss.poppins.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              if (widget.type != null && widget.type != "")
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: widget.type == "credit"
                        ? Colors.green
                        : widget.type == "COD"
                            ? Colors.red
                            : Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  child: Text(
                    widget.type ?? "",
                    style: AppCss.poppins.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              if (widget.person != null && widget.person != "")
                Text(
                  widget.person ?? "",
                  style: AppCss.poppins.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ).paddingOnly(right: 10),
              if (widget.mobile != null && widget.mobile != "")
                Expanded(
                  child: Text(
                    widget.mobile ?? "",
                    style: AppCss.poppins.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ).paddingOnly(bottom: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.address ?? "",
                  style: AppCss.footnote.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ).paddingOnly(bottom: 5),
              ),
              TextButton(
                onPressed: widget.onTap,
                child: Text(
                  "Edit",
                  style: AppCss.footnote.copyWith(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          if (widget.notes != null && widget.notes != "")
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Notes : ",
                  style: AppCss.poppins.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.notes ?? "",
                    style: AppCss.poppins.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (widget.billNo != null && widget.billNo != "")
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Bill Number : ",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.billNo ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          Wrap(
            children: [
              if (widget.amount != null && widget.amount != "")
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Amount",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ).paddingOnly(bottom: 3),
                      Text(
                        widget.amount ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10, vertical: 2),
                ).paddingOnly(right: 2),
              if (widget.billAmount != null && widget.billAmount != "")
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bill_Amount",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ).paddingOnly(bottom: 3),
                      Text(
                        widget.billAmount ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10, vertical: 2),
                ),
              if (widget.loose != null && widget.loose != "")
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Loose Pkg",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ).paddingOnly(bottom: 3),
                      Text(
                        widget.loose ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10, vertical: 2),
                ),
              if (widget.box != null && widget.box != "")
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Box Pkg",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ).paddingOnly(bottom: 3),
                      Text(
                        widget.box ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10, vertical: 2),
                ),
            ],
          ).paddingOnly(right: 5, top: 8),
        ],
      ).paddingOnly(left: 10, right: 10, top: 10, bottom: 5),
    );
  }
}
