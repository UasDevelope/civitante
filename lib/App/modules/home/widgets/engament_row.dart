import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

Widget buildStatItem({required Widget icon, required String label}) {
  return Row(
    children: [
      icon,
      const SizedBox(width: 8),
      AppText(
          text: label,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.white)
    ],
  );
}
