import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

Widget buildActionCommunityButton({
  required String assetPath,
  required VoidCallback onTap,
  required String tooltip,
  double height=48,
  double width=48
}) {
  return Tooltip(
    message: tooltip, // Adds clarity on long press
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: height, // Larger touch target
        width: width,
        child: IconButton(
          onPressed: onTap,
          icon: Image.asset(
            assetPath,
            color: Colors.black,
            height: 24, // Keep icon size reasonable
          ),
          tooltip: tooltip, // Redundant with Tooltip widget, but good practice
        ),
      ),
    ),
  );
}