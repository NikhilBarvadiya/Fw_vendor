// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String? title;
  final GestureTapCallback? onPress;
  final IconData? icon;
  final Color? iconColor;
  final bool? showArrow;
  final String? subtitle;
  final dynamic iconSize;

  const MenuCard({
    Key? key,
    this.title,
    this.onPress,
    this.icon,
    this.iconColor = Colors.grey,
    this.showArrow = true,
    this.subtitle,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress!,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize ?? 20,
        ),
      ),
      title: Text("$title"),
      subtitle: subtitle != null ? Text("${subtitle.toString()}") : null,
    );
  }
}
