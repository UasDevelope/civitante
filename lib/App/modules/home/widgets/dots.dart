import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color:AppColors.Slate_gray,
        shape: BoxShape.circle,
      ),
    );
  }
}
