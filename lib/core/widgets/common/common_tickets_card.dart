import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonTicketsCard extends StatefulWidget {
  final String? orderNo;
  final String? shopName;
  final String? addressDate;
  final String? reOpenStatus;
  final void Function()? onPressed;

  const CommonTicketsCard({
    Key? key,
    this.addressDate,
    this.orderNo,
    this.reOpenStatus,
    this.onPressed,
    this.shopName,
  }) : super(key: key);

  @override
  State<CommonTicketsCard> createState() => _CommonTicketsCardState();
}

class _CommonTicketsCardState extends State<CommonTicketsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        elevation: 1,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.shopName != null && widget.shopName != "")
                Text(
                  widget.shopName ?? "",
                  style: AppCss.h3,
                ),
              if (widget.orderNo != null && widget.orderNo != "") Text(widget.orderNo ?? "", style: AppCss.body1),
              if (widget.addressDate != null && widget.addressDate != "")
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    widget.addressDate ?? "",
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
            ],
          ).paddingAll(4),
        ),
      ).paddingOnly(bottom: 10),
    );
  }
}
