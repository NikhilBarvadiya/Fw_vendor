import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';

class CommonChips extends StatelessWidget {
  final void Function()? onTap;
  final Color? borderColor;
  final Color? textColor;
  final Color? color;
  final String? text;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CommonChips({
    Key? key,
    this.onTap,
    this.color,
    this.textColor,
    this.borderColor,
    this.text,
    this.style,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 5),
          ),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: 1,
          ),
          color: color ?? Colors.transparent,
        ),
        child: Text(
          text ?? '',
          style: style ??
              AppCss.h1.copyWith(
                color: textColor ?? Colors.transparent,
              ),
        ),
      ),
    );
  }
}
