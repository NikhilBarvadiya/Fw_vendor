import 'package:flutter/material.dart';
import 'package:fw_vendor/controller/app_controller.dart';

Widget commonButton({
  void Function()? onTap,
  String? text,
  dynamic height,
  dynamic width,
  dynamic color,
  dynamic txtColor,
}) {
  return Card(
    elevation: 5,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppController().appTheme.primary1,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Container(
          height: height ?? 45,
          width: width,
          alignment: Alignment.center,
          child: Text(
            text ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: txtColor ?? Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
