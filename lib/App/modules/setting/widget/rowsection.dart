import 'dart:ui';

import '../../../utilse/widgets.dart';

Widget buildSectionRow({
  required String title,
  Widget? leading,
  Widget? trailing,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 4, horizontal: 16), // Adjust padding here
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (leading != null) leading,
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: AppText(
              text: title,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.appColor,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    ),
  );
}