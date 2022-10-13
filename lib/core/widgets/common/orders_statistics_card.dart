import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class OrdersStatisticsCard extends StatefulWidget {
  final String? totalPKG;
  final String? totalBOX;
  final String? date;
  final Widget? table;

  const OrdersStatisticsCard({
    Key? key,
    this.date,
    this.table,
    this.totalPKG,
    this.totalBOX,
  }) : super(key: key);

  @override
  State<OrdersStatisticsCard> createState() => _OrdersStatisticsCardState();
}

class _OrdersStatisticsCardState extends State<OrdersStatisticsCard> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            trailing: Icon(
              _customTileExpanded ? Icons.arrow_drop_down_circle : Icons.arrow_drop_down,
            ),
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
            collapsedIconColor: Colors.blueGrey,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.date != null && widget.date != "")
                  Text(
                    widget.date ?? "",
                    style: AppCss.caption.copyWith(color: Colors.black),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total Package:\t",
                      style: AppCss.footnote.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                    if (widget.totalPKG != null && widget.totalPKG != "")
                      Text(
                        widget.totalPKG ?? "",
                        style: AppCss.h3.copyWith(color: Colors.black),
                      ),
                    const Spacer(),
                    Text(
                      "Total Box:\t",
                      style: AppCss.footnote.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                    if (widget.totalBOX != null && widget.totalBOX != "")
                      Text(
                        widget.totalBOX ?? "",
                        style: AppCss.h3.copyWith(color: Colors.black),
                      ),
                  ],
                ).paddingOnly(top: 5),
              ],
            ),
            children: [
              if (widget.table != null) Container(child: widget.table),
            ],
          ),
        ],
      ),
    );
  }
}
