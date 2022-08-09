import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';

Widget customNotesText({
  Color? color,
  String? hintText,
  double? height,
  dynamic prefix,
  dynamic controller,
}) {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        cursorHeight: 20,
        style: AppCss.footnote.copyWith(
          fontSize: 15,
          color: Colors.black,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefix: prefix,
          contentPadding: const EdgeInsets.only(left: 15),
          border: InputBorder.none,
          hintText: hintText ?? '',
          hintStyle: AppCss.footnote,
        ),
      ),
    ),
  );
}
