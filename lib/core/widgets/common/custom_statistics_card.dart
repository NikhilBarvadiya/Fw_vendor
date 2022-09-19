// ignore_for_file: non_constant_identifier_namesimport 'package:flutter/material.dart';import 'package:fw_vendor/core/theme/index.dart';Widget CustomStatisticsCard({  dynamic onTap,  dynamic icon,  Color? color,  String? title,  String? count,  context,}) {  return GestureDetector(    onTap: onTap,    child: Card(      child: Container(        padding: const EdgeInsets.only(top: 15, left: 8, bottom: 15),        child: Column(          mainAxisSize: MainAxisSize.min,          crossAxisAlignment: CrossAxisAlignment.start,          children: [            Text(              title ?? '',              style: AppCss.h2.copyWith(fontSize: 15),            ),            const SizedBox(height: 15),            Row(              children: [                Icon(                  icon,                  size: 40,                  color: color,                ),                const SizedBox(width: 5),                Text(                  count ?? "",                  style: AppCss.body1.copyWith(fontWeight: FontWeight.bold, fontSize: 18),                ),              ],            ),          ],        ),      ),    ),  );}