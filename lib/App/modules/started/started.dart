import 'dart:developer';

import 'package:flutter/material.dart';

import '../../utilse/widgets.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.splash),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 4),
            AppText(
              text: AppStrings.started,
              color: AppColors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButton(
                useGradient: true,
                text: AppStrings.getStarted,
                height: 60.0,
                width: double.infinity,
                color: Colors.blue,
                radius: 30,
                onPressed: () {
                  // NotificationUtil().showNotification(
                  //   RemoteMessage(
                  //     notification: RemoteNotification(
                  //       apple: AppleNotification(
                  //           sound: AppleNotificationSound(
                  //               critical: true, name: "sound.caf")),
                  //       title: "Test Notification",
                  //       body: "This is a local test notification.",
                  //     ),
                  //     data: {"key": "value", "notificationType": "message"},
                  //   ),
                  // );
                  log('Redirecting to LoginScreen --> ${AppRoutes.login}');
                  Get.toNamed(AppRoutes.login);
                },
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
