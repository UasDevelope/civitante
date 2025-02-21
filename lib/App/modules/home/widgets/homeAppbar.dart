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

  const HomeAppbar({
    Key? key,
    required this.title,
    this.imagePath,
    this.rightIcon,
    this.rightIcon2,
    this.onRightIconPressed,
    this.onRightIconPressed1,
    this.backButton = true,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.find<LocationController>();

    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: backButton,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null) ...[
            Image.asset(
              imagePath.toString(),
              color: AppColors.appColor,
              height: 20,
            ),
            const SizedBox(width: 8),
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
