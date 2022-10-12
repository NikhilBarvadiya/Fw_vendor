import 'package:flutter/material.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final String body;

  const NoDataWidget({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != "")
            Text(
              title,
              style: AppCss.h2.copyWith(color: AppController().appTheme.primary1),
            ).paddingOnly(bottom: 5),
          Text(
            body,
            style: AppCss.body3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
