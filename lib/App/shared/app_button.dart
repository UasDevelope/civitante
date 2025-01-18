import 'package:civitante/App/shared/app_text.dart';
import 'package:flutter/material.dart';

Widget AppButton({
  required String text, // Button text
  double height = 50.0, // Button height (default is 50)
  double width = double.infinity, // Button width (default is full width)
  Color color = Colors.black, // Button color (default is black)
  double radius = 8.0, // Border radius (default is 8.0)
  String? image, // Optional image URL or asset path
  required void Function()? onPressed, // Button press callback function
  bool useGradient = false, // Flag to determine if a gradient should be used
  bool hasBorder = false, // Flag to add a border
  Color borderColor = Colors.black, // Border color
  Color textColor = Colors.black, // Text color
  double borderWidht = 0.0,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: useGradient ? null : color, // Set color if no gradient
      fixedSize: Size(width, height), // Button size
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius), // Border radius
        side: hasBorder
            ? BorderSide(color: borderColor, width: 1) // Add border if true
            : BorderSide.none,
      ),
      elevation: 5, // Elevation of the button
      padding:
          EdgeInsets.zero, // Remove padding to handle the gradient properly
    ),
    onPressed: onPressed,
    child: Ink(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(width: borderWidht, color: borderColor),
          gradient: useGradient
              ? LinearGradient(
                  colors: [
                    Color(0xFFBEBEBE), // Gradient start color
                    Color(0xFF9E9E9E), // Gradient end color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(radius),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) ...[
              Image.asset(
                image, // Image if provided
                height: height * 0.5, // Image height relative to button height
                width: height * 0.5, // Image width relative to button height
              ),
              SizedBox(width: 10), // Space between image and text
            ],
            AppText(
              text: text,
              color: textColor, // Text color
              fontSize: 14, // Font size
              fontWeight: FontWeight.w600, // Font weight
            ),
          ],
        ),
      ),
    ),
  );
}
