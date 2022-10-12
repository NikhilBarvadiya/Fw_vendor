import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get.dart';

class ReturnOrdersCard extends StatefulWidget {
  final String? billNo;
  final String? addressName;
  final String? personName;
  final String? mobile;
  final String? address;
  final String? notes;
  final String? anyNote;
  final String? driverNotes;

  const ReturnOrdersCard({
    Key? key,
    this.addressName,
    this.personName,
    this.mobile,
    this.address,
    this.billNo,
    this.notes,
    this.anyNote,
    this.driverNotes,
  }) : super(key: key);

  @override
  State<ReturnOrdersCard> createState() => _ReturnOrdersCardState();
}

class _ReturnOrdersCardState extends State<ReturnOrdersCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.addressName != null && widget.addressName != "") Expanded(child: Text(widget.addressName ?? "", style: AppCss.h2)),
                if (widget.billNo != null && widget.billNo != "")
                  Card(
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    color: Colors.blue,
                    child: Text(widget.billNo ?? "", style: AppCss.h3.copyWith(color: Colors.white)).paddingOnly(left: 5, right: 5),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.personName != null && widget.personName != "") Text(widget.personName ?? "", style: AppCss.body1),
                if (widget.mobile != null && widget.mobile != "") Text(widget.mobile ?? "", style: AppCss.body1),
              ],
            ),
            if (widget.address != null && widget.address != "")  Text(widget.address ?? "", style: AppCss.caption),
            if (widget.notes != null && widget.notes != "") Text(widget.notes ?? "", style: AppCss.caption),
            if (widget.anyNote != null && widget.anyNote != "") Text(widget.anyNote ?? "", style: AppCss.caption),
            if (widget.driverNotes != null && widget.driverNotes != "") Text(widget.driverNotes ?? "", style: AppCss.caption),
          ],
        ).paddingAll(5),
      ),
    ).paddingAll(10);
  }
}
