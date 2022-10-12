import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/common_request_address_chip.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class RequestComplaintCard extends StatefulWidget {
  final String? addressName;
  final String? mobileNumber;
  final String? address;
  final String? date;
  final String? type;
  final Color? cardColors;
  final void Function() onDeleteClick;
  final void Function() onEditClick;

  const RequestComplaintCard({
    Key? key,
    this.addressName,
    this.mobileNumber,
    this.address,
    this.date,
    this.type,
    this.cardColors,
    required this.onDeleteClick,
    required this.onEditClick,
  }) : super(key: key);

  @override
  State<RequestComplaintCard> createState() => _RequestComplaintCardState();
}

class _RequestComplaintCardState extends State<RequestComplaintCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).canvasColor,
      semanticContainer: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: widget.cardColors ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.addressName != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.addressName ?? "",
                          style: AppCss.h3.copyWith(color: Colors.black, fontSize: 15),
                        ).paddingOnly(bottom: 5),
                        Row(
                          children: [
                            Text(
                              widget.date ?? "",
                              style: AppCss.footnote.copyWith(color: Colors.black),
                            ).paddingOnly(right: 8),
                            if (widget.mobileNumber != null && widget.mobileNumber != "")
                              Text(
                                widget.mobileNumber ?? "",
                                style: AppCss.body1.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (widget.type != null)
                  Card(
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    surfaceTintColor: Theme.of(context).canvasColor,
                    semanticContainer: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                    color: Colors.green,
                    child: Text(
                      widget.type ?? "",
                      style: AppCss.footnote.copyWith(color: Colors.white),
                    ).paddingAll(5),
                  ),
              ],
            ).paddingOnly(bottom: 5),
            Row(
              children: [
                CommonRequestAddressChips(
                  status: "Edit",
                  color: Colors.blue,
                  icon: FontAwesomeIcons.penToSquare,
                  onTap: widget.onEditClick,
                ),
                CommonRequestAddressChips(
                  status: "Delete",
                  color: Colors.red,
                  icon: FontAwesomeIcons.deleteLeft,
                  onTap: widget.onDeleteClick,
                ),
              ],
            ),
            if (widget.address != null && widget.address != "")
              Wrap(
                children: [
                  Text(
                    widget.address ?? "",
                    style: AppCss.poppins.copyWith(color: Colors.black, fontSize: 12),
                  ).paddingOnly(top: 8),
                ],
              ),
          ],
        ),
      ),
    ).paddingOnly(bottom: 4);
  }
}
