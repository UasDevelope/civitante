import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';
import '../../profile/controller/profile_controller.dart';

Widget buildNavItem({
  required String icon,
  required bool isActive,
  required VoidCallback onTap,
}) {
  final profileController = Get.find<ProfileController>();
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              height: 30,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ],
        ),
        // Show "Free" badge only for the "Add" item
        if (icon == AppImages.add && profileController.postFree.value > 0)
          Positioned(
            top: -5, // Adjust position to sit above the icon
            right: -5, // Adjust position to align with the icon
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent
                    .withValues(alpha: 0.9), // Subtle green background
                borderRadius: BorderRadius.circular(10), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Free',
                style: TextStyle(
                  color: Colors.black87, // Dark text for contrast
                  fontSize: 10, // Small font size to keep it subtle
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
