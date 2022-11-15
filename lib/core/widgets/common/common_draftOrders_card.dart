// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonDraftOrdersCard extends StatefulWidget {
  final String? name;
  final String? address;
  final String? billNumber;
  final String? loose;
  final String? box;
  final String? amount;
  final String? billAmount;
  final String? type;
  final String? notes;
  final Color? color;
  final Color? cardColor;
  final void Function()? onTap;

  const CommonDraftOrdersCard({
    Key? key,
    this.name,
    this.address,
    this.billNumber,
    this.loose,
    this.box,
    this.amount,
    this.billAmount,
    this.type,
    required this.color,
    required this.cardColor,
    this.notes,
    this.onTap,
  }) : super(key: key);

  @override
  State<CommonDraftOrdersCard> createState() => _CommonDraftOrdersCardState();
}

class _CommonDraftOrdersCardState extends State<CommonDraftOrdersCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Theme.of(context).canvasColor,
        semanticContainer: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        color: widget.color ?? Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.name != null && widget.name != "")
                  Expanded(
                    child: Text(widget.name ?? "", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                if (widget.billNumber != null && widget.billNumber != "")
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Bill No :\t", style: AppCss.body1.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                      Text(widget.billNumber ?? "", style: AppCss.caption.copyWith(color: Colors.black, fontSize: 12)),
                    ],
                  ),
              ],
            ).paddingOnly(bottom: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.address != null && widget.address != "")
                  Expanded(
                    child: Text(widget.address ?? "", style: AppCss.caption.copyWith(color: Colors.black, fontSize: 12)),
                  ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: widget.type == "Credit"
                        ? Colors.blueAccent.shade100
                        : widget.type == "Cash"
                            ? Colors.greenAccent.shade100
                            : Colors.greenAccent.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  child: Text(
                    widget.type ?? "",
                    style: AppCss.poppins.copyWith(
                      color: widget.type == "Credit"
                          ? Colors.blue
                          : widget.type == "Cash"
                              ? Colors.green
                              : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ).paddingOnly(left: 10),
              ],
            ),
            if (widget.notes != null && widget.notes != "")
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Notes : ", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(widget.notes ?? "", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 14)),
                  ),
                ],
              ).paddingOnly(top: 5, left: 1),
            Wrap(
              children: [
                if (widget.amount != null && widget.amount != "")
                  Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                    color: widget.cardColor ?? Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Amount",
                          style: AppCss.poppins.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ).paddingOnly(bottom: 3),
                        Text(widget.amount ?? "", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 12)),
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 2),
                  ).paddingOnly(right: 2),
                if (widget.billAmount != null && widget.billAmount != "")
                  Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                    color: widget.cardColor ?? Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Bill_Amount",
                          style: AppCss.poppins.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ).paddingOnly(bottom: 3),
                        Text(widget.billAmount ?? "", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 12)),
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 2),
                  ),
                if (widget.loose != null && widget.loose != "")
                  Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                    color: widget.cardColor ?? Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Loose Pkg",
                          style: AppCss.poppins.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ).paddingOnly(bottom: 3),
                        Text(widget.loose ?? "", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 12)),
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 2),
                  ),
                if (widget.box != null && widget.box != "")
                  Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                    color: widget.cardColor ?? Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Box Pkg",
                          style: AppCss.poppins.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ).paddingOnly(bottom: 3),
                        Text(widget.box ?? "", style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 12)),
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 2),
                  ),
              ],
            ),
          ],
        ).paddingAll(8),
      ),
    );
  }
}
