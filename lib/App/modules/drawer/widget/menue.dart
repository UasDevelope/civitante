import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../../utilse/SharedPreferencesHelper.dart';

class MenuItem extends StatelessWidget {
  final String imagePath; // Path for the image
  final String title; // The title of the menu item
  final String routeName; // The route name for navigation
  final Color imageColor;
  MenuItem(
      {required this.imagePath,
      required this.title,
      required this.routeName,
      required this.imageColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        color: imageColor,
        height: 30,
      ), // Image based on the provided path
      title: AppText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.appColor), // Title text
      onTap: () async {
        if (routeName == '/login') {
          await SharedPreferencesHelper.clearUserId();
        }
        Get.toNamed(routeName); // Navigate to the route name when tapped
        print("routeName${routeName}");
      },
    );
  }
}
