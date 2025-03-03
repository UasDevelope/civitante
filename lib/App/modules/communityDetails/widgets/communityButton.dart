import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

Widget buildActionCommunityButton(String assetPath, VoidCallback onTap) {
  return SizedBox(
    height: 30,
    width: 30,
    child: GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        color: Colors.black,
      ),
    ),
  );
}
