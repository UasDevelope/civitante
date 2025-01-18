import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';

Widget buildDivider() {
  return Divider(
    color:AppColors.light_gray,
    thickness: 0.4,
    height: 0, // Remove space after the divider
  );
}