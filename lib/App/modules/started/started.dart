import 'dart:developer';
import 'package:civitante/App/shared/strings.dart';
import 'package:flutter/material.dart';
import '../../utilse/widgets.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width + 20,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  AppImages.splash,
                ),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.6),
            AppText(
                text: AppStrings.started,
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center),
            SizedBox(
              height: Get.height / 7,
            ),
            Center(
              child: AppButton(
                useGradient: true,
                text: AppStrings.getStarted,
                height: 60.0,
                width: Get.width / 1.2,
                color: Colors.blue,
                radius: 30,
                onPressed: () {
                  log('==============Redirecting to LoginScreen================>Routes-------->${AppRoutes.login}');
                  Get.toNamed(AppRoutes.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
