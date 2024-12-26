import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocateController.splashController;
    return Scaffold(
        backgroundColor: AppColors.appColor,
        body: Image.asset(AppImages.splash));
  }
}
