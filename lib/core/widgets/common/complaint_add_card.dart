import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get.dart';

class ComplaintAddCard extends StatefulWidget {
  final String? billNo;
  final String? orderNo;
  final String? addressName;
  final String? personName;
  final String? mobile;
  final String? address;
  final String? notes;
  final String? anyNote;
  final String? driverNotes;
  final void Function()? onPressed;

  const ComplaintAddCard({
    Key? key,
    this.addressName,
    this.personName,
    this.mobile,
    this.address,
    this.billNo,
    this.orderNo,
    this.notes,
    this.anyNote,
    this.driverNotes,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ComplaintAddCard> createState() => _ComplaintAddCardState();
}

class _ComplaintAddCardState extends State<ComplaintAddCard> {
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
            if (widget.orderNo != null && widget.orderNo != "") Text(widget.orderNo ?? "", style: AppCss.h3.copyWith(fontWeight: FontWeight.w400)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.personName != null && widget.personName != "") Text(widget.personName ?? "", style: AppCss.body1),
                if (widget.mobile != null && widget.mobile != "") Text(widget.mobile ?? "", style: AppCss.body1),
              ],
            ),
            Row(
              children: [
                if (widget.address != null && widget.address != "") Expanded(child: Text(widget.address ?? "", style: AppCss.caption)),
                InputChip(
                  elevation: 1,
                  onPressed: widget.onPressed,
                  shadowColor: Colors.deepOrange.shade500,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  backgroundColor: Colors.white,
                  label: Text(
                    "Raise Ticket",
                    style: AppCss.poppins.copyWith(color: Colors.deepOrange.shade500, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (widget.notes != null && widget.notes != "") Text(widget.notes ?? "", style: AppCss.caption),
            if (widget.anyNote != null && widget.anyNote != "") Text(widget.anyNote ?? "", style: AppCss.caption),
            if (widget.driverNotes != null && widget.driverNotes != "") Expanded(child: Text(widget.driverNotes ?? "", style: AppCss.caption)),
          ],
        ).paddingAll(5),
      ),
    ).paddingAll(10);
  }
}
