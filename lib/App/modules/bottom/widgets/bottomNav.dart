import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

Widget buildNavItem({
  required String icon,
  required bool isActive,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon,
            height: 30, color: isActive ? Colors.white : Colors.grey),
      ],
    ),
  );
}
