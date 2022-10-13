import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/env.dart';
import 'package:get/get.dart';

class ComplaintView extends StatefulWidget {
  final String? orderNo;
  final String? currentStatus;
  final String? reOpenStatus;
  final String? shopName;
  final String? addressDate;
  final String? notes;
  final List? images;
  final void Function()? onStatus;

  const ComplaintView({
    Key? key,
    this.shopName,
    this.addressDate,
    this.orderNo,
    this.images,
    this.notes,
    this.reOpenStatus,
    this.onStatus,
    this.currentStatus,
  }) : super(key: key);

  @override
  State<ComplaintView> createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            side: BorderSide(
              color: widget.currentStatus == "Open"
                  ? Colors.green
                  : widget.currentStatus == "Resolved"
                      ? Colors.amber
                      : widget.currentStatus == "Reopen"
                          ? Colors.blue
                          : Colors.transparent,
            ),
          ),
          color: widget.currentStatus == "Open"
              ? Colors.green
              : widget.currentStatus == "Resolved"
                  ? Colors.amber
                  : widget.currentStatus == "Reopen"
                      ? Colors.blue
                      : Colors.transparent,
          child: Row(
            children: [
              Text(
                "Current Status ",
                style: AppCss.footnote.copyWith(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                widget.currentStatus ?? "",
                style: AppCss.footnote.copyWith(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              if (widget.addressDate != null && widget.addressDate != "") Text(widget.addressDate ?? "", style: AppCss.footnote),
            ],
          ).paddingAll(10),
        ),
        Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          shadowColor: widget.currentStatus == "Open"
              ? Colors.green
              : widget.currentStatus == "Resolved"
                  ? Colors.amber
                  : widget.currentStatus == "Reopen"
                      ? Colors.blue
                      : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
            side: BorderSide(
              color: widget.currentStatus == "Open"
                  ? Colors.green
                  : widget.currentStatus == "Resolved"
                      ? Colors.amber
                      : widget.currentStatus == "Reopen"
                          ? Colors.blue
                          : Colors.transparent,
              width: 0.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.shopName != null && widget.shopName != "") Text(widget.shopName ?? "", style: AppCss.footnote.copyWith(fontSize: 15)),
              if (widget.orderNo != null && widget.orderNo != "") Text(widget.orderNo ?? "", style: AppCss.body1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.notes ?? "", style: AppCss.footnote),
                      Text(widget.images!.isNotEmpty ? "Images :" : "Images : N/A", style: AppCss.footnote),
                    ],
                  ),
                  if (widget.reOpenStatus != null && widget.reOpenStatus != "")
                    InputChip(
                      elevation: 1,
                      onPressed: widget.onStatus!,
                      shadowColor: widget.reOpenStatus == "Open"
                          ? Colors.green
                          : widget.reOpenStatus == "Resolve"
                              ? Colors.amber
                              : widget.reOpenStatus == "reOpen"
                                  ? Colors.red
                                  : Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      backgroundColor: widget.reOpenStatus == "Open"
                          ? Colors.green
                          : widget.reOpenStatus == "Resolve"
                              ? Colors.amber
                              : widget.reOpenStatus == "reOpen"
                                  ? Colors.red
                                  : Colors.transparent,
                      label: Text(
                        widget.reOpenStatus ?? "",
                        style: AppCss.poppins.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                ],
              ),
              if (widget.images!.isNotEmpty)
                Wrap(
                  children: [
                    ...widget.images!.map((img) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          environment["imagesbaseUrl"] + img,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ).paddingOnly(right: 5, bottom: 5, top: 5);
                    }).toList(),
                  ],
                ),
            ],
          ).paddingOnly(left: 10, right: 10, bottom: 10, top: 4),
        ),
      ],
    ).paddingAll(10);
  }
}
