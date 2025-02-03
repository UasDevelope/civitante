import 'dart:developer';

import 'package:flutter/material.dart';

Widget customTextFormField({
  required TextEditingController controller, // TextController for managing text
  TextInputType keyboardType =
      TextInputType.text, // Default keyboard type is text
  String? hintText, // Optional hint text
  String? labelText, // Optional label text
  bool obscureText =
      false, // Whether the text should be obscured (e.g. for passwords)
  Icon? prefixIcon, // Optional prefix icon
  Icon? suffixIcon, // Optional suffix icon (e.g., for showing/hiding password)
  Color borderColor = Colors.black, // Border color
  Color fillColor = Colors.white, // Fill color
  double height = 50.0, // Height of the text field
  double width = double.infinity, // Width of the text field
  double borderRadius = 8.0, // Border radius
  Function(String)? onChanged, // Function for onChanged callback
  Function()? obsecureonTap, // Function for onTap callback
  bool isPasswordField = false, // Is it a password field
  String? Function(String?)? validatore,
  IconData? icon,
  int? maxLines, // Optional maxLines parameter (null for unlimited lines)
}) {
  return TextFormField(
    maxLines: maxLines,
    controller: controller,
    keyboardType: keyboardType == TextInputType.text
        ? TextInputType.multiline // Allow multiline input
        : keyboardType,
    obscureText: isPasswordField ? obscureText : false,
    onChanged: onChanged,
    validator: validatore,
    // maxLines: isPasswordField ? 1 : maxLines ?? null, // Single line for passwords, multiline otherwise
    decoration: InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: icon != null
          ? IconButton(
              icon: Icon(icon),
              onPressed: obsecureonTap,
            )
          : null,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor.withOpacity(0.5), // Lighter border when inactive
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor,
          width: 2.0, // Thicker border when focused
        ),
      ),
    ),
    style: TextStyle(
      fontSize: 16.0,
    ),
  );
}
