import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';

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
        children: [
          Text(
            title,
            style: AppCss.h2.copyWith(color: AppController().appTheme.primary1),
          ),
          const SizedBox(height: 5),
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
