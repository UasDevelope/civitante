import 'package:flutter/material.dart';

import '../utilse/widgets.dart';

Widget AppText({
  required String text, // Text to display
  double fontSize = 16.0, // Font size (default is 16)
  Color color = Colors.black, // Text color (default is black)
  FontWeight fontWeight = FontWeight.normal, // Font weight (default is normal)
  TextAlign textAlign = TextAlign.start, // Text alignment (default is start)
}) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}
