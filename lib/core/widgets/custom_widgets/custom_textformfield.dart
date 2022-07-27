// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? container;
  final String? hint;
  final String? hintText;
  final String? labelText;
  final String? counterText;
  final double radius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final double padding;
  final Color? fillColor;
  final int maxLines;
  final int? maxLength;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  List<TextInputFormatter>? inputFormatters;

  CustomTextFormField({
    Key? key,
    this.container,
    this.hint,
    this.hintText,
    this.labelText,
    this.radius = 10.0,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.obscureText = false,
    this.validator,
    this.padding = 10,
    this.fillColor,
    this.maxLines = 1,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.readOnly = false,
    this.counterText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: container,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: counterText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: (10)),
                child: prefixIcon,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: (10)),
                child: suffixIcon,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular((radius)),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
        filled: true,
        fillColor: fillColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        contentPadding: EdgeInsets.all((padding)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
        labelText: labelText,
      ),
      style: style,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
    );
  }
}
