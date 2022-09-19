import 'package:flutter/material.dart';
import 'package:fw_vendor/common_controller/app_controller.dart';

Widget commonButton({
  void Function()? onTap,
  String? text,
  dynamic height,
  dynamic width,
  dynamic color,
  dynamic txtColor,
  dynamic elevation,
  dynamic borderRadius,
  dynamic margin,
}) {
  return Card(
    elevation: elevation ?? 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius ?? 8),
      ),
    ),
    margin: margin,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppController().appTheme.primary1,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 8),
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
