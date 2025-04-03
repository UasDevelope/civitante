import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/app_text.dart';
import '../../shared/color.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Terms & Conditions",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppColors.appColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Welcome to Civiats!",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    SizedBox(height: 10),
                    AppText(
                      text:
                          "By using Civiats, you agree to the following terms...",
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    SizedBox(height: 20),
                    AppText(
                      text: "1. User Responsibilities",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "You must not share illegal, harmful, or offensive content.",
                      fontSize: 16,
                    ),
                    SizedBox(height: 10),
                    AppText(
                      text: "2. Privacy Policy",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "We collect your data to improve our services but do not sell it to third parties.",
                      fontSize: 16,
                    ),
                    SizedBox(height: 10),
                    AppText(
                      text: "3. Account Security",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "Keep your account safe by not sharing passwords with others.",
                      fontSize: 16,
                    ),
                    SizedBox(height: 10),
                    AppText(
                      text: "4. Changes to Terms",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                    AppText(
                      text:
                          "We reserve the right to modify these terms at any time.",
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: AppText(
                text: "Accept & Continue",
                fontSize: 16,
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
