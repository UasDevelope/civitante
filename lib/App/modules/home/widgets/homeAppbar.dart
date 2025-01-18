import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? imagePath; // Optional icon for the title
  final String? rightIcon; // Optional icon on the right
  final VoidCallback? onRightIconPressed;

  const HomeAppbar({
    Key? key,
    required this.title,
    this.imagePath, // Pass an icon to display next to the title
    this.rightIcon, // Pass an icon for the right side
    this.onRightIconPressed, // Action for the right icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
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
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.appColor)
        ],
      ),
      actions: [
        if (rightIcon != null)
          IconButton(
            icon: Image.asset(
              rightIcon.toString(),
              color: Colors.black,
              height: 30,
            ),
            onPressed: onRightIconPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
