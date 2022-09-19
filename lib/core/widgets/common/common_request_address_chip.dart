// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonRequestAddressChips extends StatelessWidget {
  final String? status;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;
  void Function()? onTap;
  CommonRequestAddressChips({
    Key? key,
    this.status,
    this.onTap,
    this.color,
    this.backgroundColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor.withOpacity(0.5),
      avatar: icon != null
          ? Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 12,
              ),
            )
          : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      elevation: 1,
      label: Text(
        status ?? "",
        style: AppCss.footnote.copyWith(color: color),
      ),
      onPressed: onTap!,
    ).paddingOnly(right: 5);
  }
}
