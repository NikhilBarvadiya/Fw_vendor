// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:get/get.dart';

Widget commonTextField({
  TextEditingController? controller,
  FocusNode? focusNode,
  TextInputType? keyboardType,
  int? maxLength,
  String? hintText,
  String? labelText,
  dynamic height,
  dynamic width,
  dynamic minLines,
  dynamic maxLines,
  dynamic contentPadding,
  bool readOnly = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText ?? '',
        style: AppCss.h3,
      ),
      Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: readOnly == true ? Colors.grey.shade300 : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        ),
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: TextFormField(
            autofocus: false,
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            maxLength: maxLength,
            minLines: minLines,
            maxLines: maxLines,
            readOnly: readOnly,
            style: AppCss.body1.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              counterText: '',
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              contentPadding: contentPadding ?? const EdgeInsets.only(left: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    ],
  ).paddingOnly(bottom: 10);
}
