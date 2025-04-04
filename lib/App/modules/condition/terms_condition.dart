import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/app_text.dart';
import '../../shared/color.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Terms & Conditions",
          fontSize: isTablet ? 22 : 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppColors.appColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: isTablet ? 30 : 24,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 40.0 : 20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Welcome to Civiats!",
                      fontSize: isTablet ? 28 : 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text:
                          "By using Civiats, you agree to the following terms...",
                      fontSize: isTablet ? 18 : 16,
                      color: Colors.black54,
                    ),
                    SizedBox(height: isTablet ? 30 : 20),
                    AppText(
                      text: "1. User Responsibilities",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "You must not share illegal, harmful, or offensive content.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text: "2. Privacy Policy",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "We collect your data to improve our services but do not sell it to third parties.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text: "3. Account Security",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "Keep your account safe by not sharing passwords with others.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text: "4. Location Access",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "We may request access to your location to provide localized services. You can choose to allow or deny this permission at any time.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text: "5. Image and Media Access",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "We may request access to your camera or gallery for uploading images. We do not use your images for any other purpose unless explicitly stated.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text: "6. Notifications",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "You may receive push notifications about updates, offers, or activity. You can control these settings from your device.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text: "7. Changes to Terms",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "We reserve the right to modify these terms at any time. Continued use of the app after changes means you accept the updated terms.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                    SizedBox(height: isTablet ? 20 : 10),
                    AppText(
                      text: "8. Payments and Transactions",
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "Certain features may require payment. All transactions are processed securely. Refunds, if applicable, are handled according to our refund policy. Please ensure payment information is accurate and up to date.",
                      fontSize: isTablet ? 18 : 16,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isTablet ? 30 : 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 18 : 14,
                  horizontal: isTablet ? 60 : 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: AppText(
                text: "Accept & Continue",
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
