import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class Dot extends StatelessWidget {

  final VoidCallback onPress;
  final Color color;

  const Dot({super.key, required this.onPress, this.color = AppColors.Slate_gray});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 18,
        width: 18,
        decoration: BoxDecoration(
          color:color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
