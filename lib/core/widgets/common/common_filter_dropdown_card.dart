// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonFilterDropDown extends StatefulWidget {
  final void Function()? onTap;
  final String? headerName;
  final String? selectedName;
  final double? bottom;

  const CommonFilterDropDown({
    Key? key,
    this.onTap,
    this.selectedName,
    this.headerName,
    this.bottom,
  }) : super(key: key);

  @override
  State<CommonFilterDropDown> createState() => _CommonFilterDropDownState();
}

class _CommonFilterDropDownState extends State<CommonFilterDropDown> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.headerName != null && widget.headerName != "")
            Text(
              widget.headerName ?? "",
              style: AppCss.h2,
            ).paddingOnly(bottom: 5),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(4),
              border: Border.all(
                color: Colors.blueGrey.withOpacity(0.8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(widget.selectedName ?? "", style: AppCss.body1)),
                Icon(Icons.arrow_drop_down, color: Colors.blueGrey.withOpacity(0.8)),
              ],
            ),
          ),
        ],
      ).paddingOnly(bottom: widget.bottom ?? 15),
    );
  }
}
