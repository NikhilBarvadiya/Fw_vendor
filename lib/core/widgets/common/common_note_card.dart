import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get.dart';

class CommonNoteCard extends StatelessWidget {
  final String? note;

  const CommonNoteCard({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[1],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note",
            style: AppCss.h1.copyWith(fontWeight: FontWeight.bold, color: AppController().appTheme.primary1.withOpacity(0.3)),
          ).paddingOnly(bottom: 10),
          Expanded(
            child: ListView(
              children: [
                Html(data: note),
              ],
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 10, vertical: 15),
    );
  }
}
