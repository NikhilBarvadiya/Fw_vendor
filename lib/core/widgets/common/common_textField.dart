// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:fw_vendor/core/theme/index.dart';

Widget commonTextField({
  TextEditingController? controller,
  TextInputType? keyboardType,
  int? maxLength,
  String? hintText,
  String? labelText,
  dynamic height,
  dynamic width,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText ?? '',
        style: AppCss.h3.copyWith(
          color: AppController().appTheme.bgGray,
        ),
      ),
      Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
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
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: InputDecoration(
              counterText: '',
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              contentPadding: const EdgeInsets.only(left: 15),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    ],
  );
}
