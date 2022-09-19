import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get_utils/get_utils.dart';

class CommonCashSettlementCard extends StatefulWidget {
  final String? orderNo;
  final String? personName;
  final String? mobile;
  final String? address;
  final String? date;
  final String? cashAmount;
  final String? receivedAmount;
  const CommonCashSettlementCard({
    Key? key,
    this.orderNo,
    this.personName,
    this.mobile,
    this.address,
    this.date,
    this.cashAmount,
    this.receivedAmount,
  }) : super(key: key);

  @override
  State<CommonCashSettlementCard> createState() => _CommonCashSettlementCardState();
}

class _CommonCashSettlementCardState extends State<CommonCashSettlementCard> {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.orderNo != null && widget.orderNo != "")
                  Text(
                    widget.orderNo ?? "",
                    style: AppCss.h1.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  widget.date ?? "",
                  style: AppCss.footnote,
                ),
              ],
            ).paddingOnly(bottom: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.personName != null && widget.personName != "")
                      Text(
                        widget.personName ?? "",
                        style: AppCss.caption.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ).paddingOnly(right: 10),
                    if (widget.mobile != null && widget.mobile != "")
                      Text(
                        widget.mobile ?? "",
                        style: AppCss.footnote.copyWith(
                          fontSize: 13,
                        ),
                      ),
                  ],
                ).paddingOnly(bottom: 8),
                if (widget.address != null && widget.address != "")
                  Text(
                    widget.address ?? "",
                    style: AppCss.caption.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ).paddingOnly(bottom: 10),
                Row(
                  children: [
                    if (widget.cashAmount != null && widget.cashAmount != "")
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
                              "Cash Amount",
                              style: AppCss.poppins.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ).paddingOnly(bottom: 3),
                            Text(
                              widget.cashAmount ?? "",
                              style: AppCss.poppins.copyWith(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 10, vertical: 2),
                      ),
                    if (widget.receivedAmount != null && widget.receivedAmount != "")
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
                              "Received Amount",
                              style: AppCss.poppins.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ).paddingOnly(bottom: 3),
                            Text(
                              widget.receivedAmount ?? "",
                              style: AppCss.poppins.copyWith(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 10, vertical: 2),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
