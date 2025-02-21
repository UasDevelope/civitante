import 'dart:developer';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/utilse/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? imagePath; // Optional icon for the title
  final String? rightIcon; // Optional icon on the right
  final String? rightIcon2;
  final bool backButton;
  final VoidCallback? onRightIconPressed;
  final VoidCallback? onRightIconPressed1;

  const HomeAppbar(
      {Key? key,
      required this.title,
      this.imagePath, // Pass an icon to display next to the title
      this.rightIcon,
      this.rightIcon2, // Pass an icon for the right side
      this.onRightIconPressed,
      this.onRightIconPressed1,
      this.backButton = true // Action for the right icon
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationController locationController = Get.put(LocationController());
    log("Location here:>>>>>>>>>>>>>>>>>>>>>>> ${locationController.userLocation.toString()}");
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: backButton,
      // centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min, // Ensure title stays compact
        children: [
          if (imagePath != null) ...[
            Image.asset(
              imagePath.toString(),
              color: AppColors.appColor,
              height: 20,
            ),
            const SizedBox(width: 8), // Add spacing between icon and text
          ],
          AppText(
            text: (locationController.userLocation["city"] != null &&
                    locationController.userLocation["city"]
                        .toString()
                        .trim()
                        .isNotEmpty)
                ? locationController.userLocation["city"]
                : (locationController.userLocation["state"] != null &&
                        locationController.userLocation["state"]
                            .toString()
                            .trim()
                            .isNotEmpty)
                    ? locationController.userLocation["state"]
                    : locationController.userLocation["country"] ?? '',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.appColor,
          )
        ],
      ),
      actions: [
        if (rightIcon2 != null)
          IconButton(
            icon: Image.asset(
              rightIcon2.toString(),
              color: Colors.black,
              height: 30,
            ),
            onPressed: onRightIconPressed,
          ),
        if (rightIcon != null)
          IconButton(
            icon: Image.asset(
              rightIcon.toString(),
              color: Colors.black,
              height: 30,
            ),
            onPressed: onRightIconPressed1,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
