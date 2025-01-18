import 'dart:ui';

import '../../../utilse/widgets.dart';

Widget buildActionCommunityButton(String assetPath, VoidCallback onTap) {
  return SizedBox(
    height: 40,
    width: 40,
    child: GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath),
    ),
  );
}
