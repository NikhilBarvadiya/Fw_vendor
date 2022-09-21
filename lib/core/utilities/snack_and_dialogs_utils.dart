import 'package:flutter/material.dart';import 'package:fw_vendor/core/theme/app_css.dart';import 'package:fw_vendor/core/utilities/index.dart';import 'package:get/get.dart';snackBar(message, {context, duration}) {  final snackBar = SnackBar(    content: Text(      message,      style: AppCss.h2.copyWith(color: Colors.white),    ),    duration: Duration(      milliseconds: duration == 'short' ? 1000 : (duration == 'long' ? 20000 : 2000),    ),    action: SnackBarAction(      label: "ok",      onPressed: () => ScaffoldMessenger.of(context ?? Get.context).clearSnackBars(),    ),  );  ScaffoldMessenger.of(context ?? Get.context).clearSnackBars();  ScaffoldMessenger.of(context ?? Get.context).showSnackBar(snackBar);}errorDialog(message) {  Get.defaultDialog(    barrierDismissible: false,    radius: 4,    title: "",    titleStyle: const TextStyle(fontSize: 10),    titlePadding: EdgeInsets.zero,    contentPadding: const EdgeInsets.symmetric(      vertical: 0,      horizontal: 12,    ),    actions: [      TextButton(        onPressed: () {          Get.back();        },        child: const Text("Okay"),      )    ],    content: Column(      mainAxisSize: MainAxisSize.min,      children: [        const CircleAvatar(          radius: 30,          backgroundColor: Colors.redAccent,          child: Icon(            Icons.close,            size: 20,            color: Colors.white,          ),        ),        const SizedBox(height: 10),        Text(          message,          style: const TextStyle(fontSize: 14),        ),      ],    ),  );}appUpdateDialog(  String message, {  required VoidCallback onConfirm,  VoidCallback? onCancel,  bool forceUpdate = false,}) {  return Get.defaultDialog(    title: trans('App Update'),    middleText: message,    titleStyle: AppCss.h2,    barrierDismissible: !forceUpdate,    middleTextStyle: AppCss.body2,    contentPadding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),    titlePadding: const EdgeInsets.only(top: 15),    onWillPop: forceUpdate == true ? () async => false : null,    actions: [      if (!forceUpdate)        ElevatedButton(          onPressed: onCancel,          style: ButtonStyle(            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),            elevation: MaterialStateProperty.resolveWith<double>(              // As you said you don't need elevation. I'm returning 0 in both case              (Set<MaterialState> states) {                if (states.contains(MaterialState.disabled)) {                  return 0;                }                return 0; // Defer to the widget's default.              },            ),          ),          child: Text(            trans('cancel'),            style: AppCss.h2.copyWith(color: Colors.grey),          ),        ),      ElevatedButton(        onPressed: onConfirm,        style: ButtonStyle(          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),          elevation: MaterialStateProperty.resolveWith<double>(            // As you said you don't need elevation. I'm returning 0 in both case            (Set<MaterialState> states) {              if (states.contains(MaterialState.disabled)) {                return 0;              }              return 0; // Defer to the widget's default.            },          ),        ),        child: Text(          trans('update'),          style: AppCss.h2,        ),      ),    ],  );}