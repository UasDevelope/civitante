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
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: isPasswordField ? obscureText : false,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: isPasswordField
          ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed:obsecureonTap,
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
