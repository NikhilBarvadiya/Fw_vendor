import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

// ignore: must_be_immutable
class CommonActionChip extends StatelessWidget {
  final String count;
  final String status;
  void Function() onTap;
  Color? color;
  CommonActionChip({
    Key? key,
    required this.count,
    required this.status,
    required this.onTap,
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
        child: Text(
          count,
          style: AppCss.h3.copyWith(color: Colors.white),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      elevation: 1,
      label: Text(
        status,
        style: AppCss.h3.copyWith(color: color),
      ),
      onPressed: onTap,
    ).paddingOnly(bottom: 10, right: 5);
  }
}
