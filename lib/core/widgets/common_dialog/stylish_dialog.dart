import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

dynamic stylishDialog({
  required final BuildContext context,
  final void Function()? onPressed,
  final void Function()? onCancel,
  final String? titleText,
  final String? contentText,
  final String? txtCancelButton,
  final String? txtOkButton,
  final Color? confirmButton,
  final Color? cancelButtonColor,
  final StylishDialogType? alertType,
  final Widget? addView,
  final bool cancelButton = false,
}) {
  return StylishDialog(
    context: context,
    addView: addView,
    alertType: alertType,
    titleText: titleText,
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
      child: Text(
        txtOkButton ?? 'Ok',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  ).show();
}

dynamic successDialog({
  final String? contentText,
  final String? titleText,
  final String? txtOkButton,
  final void Function()? onPressed,
  final void Function()? onCancel,
}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    alertType: StylishDialogType.SUCCESS,
    titleText: titleText ?? 'Update success',
    contentText: contentText ?? "",
    confirmButton: Colors.green,
    onPressed: onPressed,
    cancelButton: onCancel != null ? true : false,
    onCancel: onCancel,
    txtOkButton: txtOkButton,
    cancelButtonColor: Colors.redAccent,
  );
}

dynamic warningDialog({final String? contentText, final void Function()? onPressed}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    alertType: StylishDialogType.WARNING,
    titleText: 'Warning',
    contentText: contentText ?? "",
    confirmButton: Colors.amber,
    onPressed: onPressed,
  );
}

dynamic infoDialog({final String? contentText, final String? titleText, final void Function()? onPressed}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    alertType: StylishDialogType.INFO,
    titleText: titleText ?? "",
    contentText: contentText ?? "",
    confirmButton: Colors.blueGrey,
    onPressed: onPressed,
  );
}

dynamic errorDialog({final String? contentText, final void Function()? onPressed}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    alertType: StylishDialogType.ERROR,
    titleText: 'error',
    contentText: contentText ?? "",
    confirmButton: Colors.red,
    onPressed: onPressed,
  );
}
