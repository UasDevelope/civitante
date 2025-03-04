import 'package:flutter/material.dart';
import '../utilse/widgets.dart';
Widget AppText({
  required String text,
  double fontSize = 16.0,
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
  TextAlign textAlign = TextAlign.start,
  bool OneLine = false,
}) {
  return Text(
    text,
    maxLines: OneLine? 1: null,
    overflow: OneLine ? TextOverflow.ellipsis : null,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}
