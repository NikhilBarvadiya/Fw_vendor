// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonRequestAddressChips extends StatelessWidget {
  final String? status;
  final Color? color;
  void Function()? onTap;
  CommonRequestAddressChips({
    Key? key,
    this.status,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: Theme.of(context).cardColor.withOpacity(0.5),
      avatar: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
        ),
        child: const Icon(
          FontAwesomeIcons.penToSquare,
          color: Colors.white,
          size: 12,
        ),
      ),
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
