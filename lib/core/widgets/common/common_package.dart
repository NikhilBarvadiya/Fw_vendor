// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

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
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).indicatorColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            packageLable,
            style: TextStyle(
              color: Theme.of(context).indicatorColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
