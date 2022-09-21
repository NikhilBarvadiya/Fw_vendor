// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonOrdersTextCard extends StatefulWidget {
  final String? name;
  final String? hintText;
  final Widget? suffixIcon;
  final bool? readOnly;
  final int? maxLines;
  final int? minLines;
  final dynamic elevation;
  final void Function()? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextStyle? hederStyle;

  const CommonOrdersTextCard({
    Key? key,
    this.name,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.hederStyle,
    this.elevation,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CommonOrdersTextCard> createState() => _CommonOrdersTextCardState();
}

class _CommonOrdersTextCardState extends State<CommonOrdersTextCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation ?? 1,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).canvasColor,
      semanticContainer: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name ?? "",
            style: widget.hederStyle ?? AppCss.footnote.copyWith(fontSize: 14),
          ).paddingOnly(left: 5, top: 5),
          Container(
            color: Theme.of(context).canvasColor.withOpacity(.1),
            child: TextFormField(
              autofocus: false,
              readOnly: widget.readOnly ?? false,
              onTap: widget.onTap,
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              cursorHeight: 20,
              decoration: InputDecoration(
                suffixIcon: widget.suffixIcon,
                hintText: widget.hintText,
                hintStyle: AppCss.caption.copyWith(
                  fontSize: 14,
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
              style: AppCss.caption.copyWith(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 5);
  }
}
