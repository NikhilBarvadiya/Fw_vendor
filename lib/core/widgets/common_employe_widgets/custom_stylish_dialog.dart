import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

dynamic stylishDialog({
  final BuildContext? context,
  final void Function()? onPressed,
  final void Function()? onCancel,
  final String? contentText,
  final String? txtCancelButton,
  final Color? confirmButton,
  final Color? cancelButtonColor,
  final StylishDialogType? alertType,
  final Widget? addView,
  final bool cancelButton = false,
}) {
  return StylishDialog(
    context: context!,
    addView: addView,
    alertType: alertType,
    contentText: contentText,
    dismissOnTouchOutside: false,
    cancelButton: cancelButton != false
        ? AnimatedButton(
            height: 30,
            width: Get.width * 0.3,
            color: cancelButtonColor ?? Theme.of(context).primaryColor,
            shadowDegree: ShadowDegree.light,
            enabled: true,
            shape: BoxShape.rectangle,
            onPressed: onCancel ?? () {},
            child: Text(
              txtCancelButton ?? 'Cancel',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )
        : null,
    confirmButton: AnimatedButton(
      height: 30,
      width: Get.width * 0.3,
      color: confirmButton ?? Theme.of(context).primaryColor,
      shadowDegree: ShadowDegree.light,
      enabled: true,
      shape: BoxShape.rectangle,
      onPressed: onPressed ?? () {},
      child: const Text(
        'Ok',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  ).show();
}
