import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get.dart';

class OrderAddressCard extends StatefulWidget {
  final String? addressHeder;
  final dynamic addressHederfontSize;
  final String? personName;
  final String? mobileNumber;
  final String? address;
  final String? yourAddress;
  final String? area;
  final String? date;
  final String? type;
  final Color? cardColors;
  final bool? icon;
  final double? iconSize;
  final void Function()? onTap;
  final void Function()? onTypeClick;

  const OrderAddressCard({
    super.key,
    this.addressHeder,
    this.personName,
    this.address,
    this.yourAddress,
    this.area,
    this.onTap,
    this.cardColors,
    this.icon,
    this.addressHederfontSize,
    this.mobileNumber,
    this.date,
    this.iconSize,
    this.onTypeClick,
    this.type,
  });

  @override
  State<OrderAddressCard> createState() => _OrderAddressCardState();
}

class _OrderAddressCardState extends State<OrderAddressCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Theme.of(context).canvasColor,
        semanticContainer: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        color: widget.cardColors ?? (widget.icon == true ? Colors.green[100] : Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.addressHeder != null)
                    Expanded(
                      child: Text(
                        widget.addressHeder ?? "",
                        style: AppCss.h3.copyWith(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  Container(
                    color: widget.cardColors ?? (widget.icon == true ? Colors.green[100] : Colors.white),
                    alignment: Alignment.topRight,
                    child: Icon(
                      widget.icon != true ? Icons.add : Icons.close,
                      color: widget.icon == true ? Colors.red : Colors.green,
                    ),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(bottom: 5),
              Row(
                children: [
                  if (widget.personName != null && widget.personName != "")
                    Text(
                      widget.personName ?? "",
                      style: AppCss.body1.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ).paddingOnly(right: 8),
                  if (widget.mobileNumber != null)
                    Text(
                      widget.mobileNumber ?? "",
                      style: AppCss.body1.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ).paddingOnly(bottom: 5),
              if (widget.address != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.address ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          widget.date ?? "",
                          style: AppCss.footnote.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        if (widget.type != null)
                          GestureDetector(
                            onTap: widget.onTypeClick,
                            child: Card(
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              surfaceTintColor: Theme.of(context).canvasColor,
                              semanticContainer: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              color: widget.type == "Credit"
                                  ? Colors.green
                                  : widget.type == "Cash"
                                      ? Colors.blue
                                      : Colors.green,
                              child: Text(
                                widget.type ?? "",
                                style: AppCss.footnote.copyWith(color: Colors.white),
                              ).paddingAll(5),
                            ),
                          ),
                      ],
                    ).paddingOnly(left: 8),
                  ],
                ).paddingOnly(bottom: 5),
              if (widget.area != null)
                Container(
                  padding: const EdgeInsets.all(2),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Area",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ).paddingOnly(bottom: 3),
                      Text(
                        widget.area ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.yourAddress != null)
                Container(
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(top: 5),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Address",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ).paddingOnly(bottom: 3),
                      Text(
                        widget.address ?? "",
                        style: AppCss.poppins.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ).paddingOnly(bottom: 4),
    );
  }
}
