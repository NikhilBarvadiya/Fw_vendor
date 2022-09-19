// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';

class CommonPackage extends StatelessWidget {
  int count = 0;
  String packageLable;
  CommonPackage({
    Key? key,
    required this.count,
    required this.packageLable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        border: Border.all(width: 1, color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Text(
            count.toString(),
            style: AppCss.footnote.copyWith(color: Theme.of(context).indicatorColor,fontSize: 12),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            packageLable,
            style: AppCss.footnote.copyWith(color: Theme.of(context).indicatorColor),
          ),
        ],
      ),
    );
  }
}
