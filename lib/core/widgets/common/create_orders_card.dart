import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CreateOrdersCard extends StatefulWidget {
  final String? name;
  final String? billNo;
  final String? mobileNumber;
  final String? address;
  final String? area;
  final String? amount;
  final String? type;
  final String? billAmount;
  final void Function()? onTap;

  const CreateOrdersCard({
    Key? key,
    this.name,
    this.billNo,
    this.mobileNumber,
    this.address,
    this.area,
    this.amount,
    this.billAmount,
    this.type,
    this.onTap,
  }) : super(key: key);

  @override
  State<CreateOrdersCard> createState() => _CreateOrdersCardState();
}

class _CreateOrdersCardState extends State<CreateOrdersCard> {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.name != null && widget.name != "")
                Text(
                  widget.name ?? "",
                  style: AppCss.poppins.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ).paddingOnly(right: 8),
              if (widget.billNo != null && widget.billNo != "")
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Bill No : ",
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
          ).paddingSymmetric(horizontal: 4, vertical: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.mobileNumber != null)
                Text(
                  widget.mobileNumber ?? "",
                  style: AppCss.poppins.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  ),
                ),
                color: widget.type == "Credit"
                    ? Colors.green
                    : widget.type == "Cod"
                        ? Colors.red
                        : Colors.white,
                child: Text(
                  widget.type ?? "",
                  style: AppCss.poppins.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ).paddingSymmetric(horizontal: 10, vertical: 2),
              ),
            ],
          ).paddingOnly(left: 4, right: 8, top: 2, bottom: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.address ?? "",
                      style: AppCss.caption.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    if (widget.area != null && widget.area != "")
                      Text(
                        widget.area ?? "",
                        style: AppCss.caption.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ).paddingOnly(top: 5),
                  ],
                ),
              ),
              TextButton(
                onPressed: widget.onTap,
                child: Text(
                  "Delete",
                  style: AppCss.footnote.copyWith(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ).paddingOnly(left: 5),
            ],
          ).paddingOnly(left: 4, bottom: 2, top: 2),
          Row(
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
                          fontSize: 10,
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
                ).paddingOnly(right: 5),
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
                          fontSize: 10,
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
            ],
          ).paddingOnly(right: 5, bottom: 5, top: 8),
        ],
      ),
    ).paddingOnly(bottom: 10);
  }
}
