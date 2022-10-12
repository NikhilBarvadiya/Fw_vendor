import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonTicketsCard extends StatefulWidget {
  final String? orderNo;
  final String? shopName;
  final String? addressDate;
  final String? reOpenStatus;
  final void Function()? onPressed;
  final void Function()? onStatus;

  const CommonTicketsCard({
    Key? key,
    this.addressDate,
    this.orderNo,
    this.reOpenStatus,
    this.onPressed,
    this.onStatus,
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
              Row(
                children: [
                  if (widget.shopName != null && widget.shopName != "")
                    Expanded(
                      child: Text(
                        widget.shopName ?? "",
                        style: AppCss.h3,
                      ),
                    ),
                  if (widget.reOpenStatus != null && widget.reOpenStatus != "")
                    TextButton.icon(
                      onPressed: widget.onStatus,
                      icon: const Icon(
                        FontAwesomeIcons.doorOpen,
                        size: 10,
                        color: Colors.deepOrangeAccent,
                      ),
                      label: Text(
                        widget.reOpenStatus ?? '',
                        style: AppCss.footnote.copyWith(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                ],
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
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(
                  onPressed: widget.onPressed,
                  icon: const Icon(Icons.visibility, size: 10),
                  label: Text("View", style: AppCss.footnote),
                ),
              ),
            ],
          ).paddingAll(4),
        ),
      ).paddingOnly(bottom: 10),
    );
  }
}
