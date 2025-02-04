import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatelessWidget {
  final String animationPath;
  final bool repeat;
  final double height;
  final double width;

  const LottieAnimationWidget({
    Key? key,
    this.animationPath = "assets/images/emptydata.json", // Default path
    this.repeat = true, // Unlimited loop
    this.height = 150.0, // Default height
    this.width = 150.0, // Default width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: Lottie.asset(
          animationPath,
          repeat: repeat,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
