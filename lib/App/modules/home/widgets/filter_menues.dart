import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:flutter/material.dart';

class HomeFilterMenues extends StatelessWidget {
  final void Function(String) onSelected;
  HomeFilterMenues({required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(
        minWidth: 100, // Set minimum width of the menu
        maxWidth: 150, // Set maximum width of the menu
      ),
      color: AppColors.white,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
          side: BorderSide(
            color: AppColors.textFieldHintColor, // Border color
            width: 0.4, // Border width
          )),
      icon: Image.asset(
        AppImages.filter,
        height: 20,
      ), // You can replace this with an Image if required
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            height: 30,
            value: AppStrings.comments,
            child: AppText(
                text: AppStrings.comments,
                color: AppColors.appColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          PopupMenuDivider(
            height: 1,// Thickness of the divider
          ),
          PopupMenuItem(
            height: 30,
            value: 'Likes',
            child: AppText(
                text: AppStrings.likes,
                color: AppColors.appColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ];
      },
    );
  }
}
