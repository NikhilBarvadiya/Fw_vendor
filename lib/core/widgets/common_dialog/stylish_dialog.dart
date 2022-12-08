import 'package:animated_button/animated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';
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
  final Color? backgroundColor,
  final Color? confirmButton,
  final Color? cancelButtonColor,
  final StylishDialogType? alertType,
  final TextStyle? contentStyle,
  final TextStyle? confirmButtonStyle,
  final Widget? addView,
  final bool cancelButton = false,
}) {
  return StylishDialog(
    context: context,
    addView: addView,
    alertType: alertType,
    titleText: titleText,
    contentText: contentText,
    contentStyle: contentStyle,
    backgroundColor: backgroundColor,
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
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
        style: confirmButtonStyle ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ),
  ).show();
}

informationDialog({message, backgroundColor, required VoidCallback onConfirm, title}) {
  Get.defaultDialog(
    barrierDismissible: false,
    radius: 4,
    title: "",
    titleStyle: const TextStyle(fontSize: 10),
    titlePadding: EdgeInsets.zero,
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("Cancel"),
      ),
      TextButton(onPressed: onConfirm, child: const Text("Okay")),
    ],
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: backgroundColor ?? Colors.white,
          child: Icon(CupertinoIcons.info, size: 50, color: AppController().appTheme.primary1),
        ),
        const SizedBox(height: 10),
        Text(title, style: AppCss.footnote.copyWith(fontSize: 15)),
      ],
    ),
  );
}

dynamic successDialog({
  final String? contentText,
  final String? titleText,
  final String? txtOkButton,
  final StylishDialogType? alertType,
  final void Function()? onPressed,
  final void Function()? onCancel,
}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    alertType: alertType ?? StylishDialogType.SUCCESS,
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

dynamic infoDialog({
  final String? contentText,
  final String? titleText,
  final void Function()? onPressed,
  final Color? backgroundColor,
  final Color? confirmButton,
  final TextStyle? contentStyle,
  final TextStyle? confirmButtonStyle,
}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    alertType: StylishDialogType.INFO,
    titleText: titleText ?? "Information",
    contentText: contentText ?? "",
    confirmButton: confirmButton ?? Colors.blueGrey,
    onPressed: onPressed,
  );
}

dynamic errorDialog({final String? contentText, final String? titleText, final void Function()? onPressed}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    alertType: StylishDialogType.ERROR,
    titleText: titleText ?? 'error',
    contentText: contentText ?? "",
    confirmButton: Colors.red,
    onPressed: onPressed,
  );
}

dynamic scannerErrorDialog({final void Function()? onPressed, final String? contentText}) {
  dynamic context = Get.context;
  stylishDialog(
    context: context,
    backgroundColor: Colors.redAccent.shade200,
    alertType: StylishDialogType.INFO,
    contentText: contentText,
    confirmButton: Colors.white,
    contentStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    confirmButtonStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.redAccent.shade200),
    onPressed: onPressed,
  );
}
