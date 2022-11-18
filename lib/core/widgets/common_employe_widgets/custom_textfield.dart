import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

Widget customTextField({
  required String name,
  dynamic controller,
  dynamic focusNode,
  dynamic keyboardType,
  dynamic maxLength,
  dynamic onChanged,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: TextFormField(
      autofocus: false,
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.start,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        icon: const Padding(padding: EdgeInsets.only(left: 15.0), child: Text("+91")),
        border: InputBorder.none,
        hintText: name,
        counterText: "",
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ),
  ).paddingOnly(right: 20, left: 20);
}
