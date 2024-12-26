import 'dart:developer';

import 'package:civitante/App/shared/strings.dart';
import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.authController;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Image.asset(
                    AppImages.logo,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  AppText(
                      text: AppStrings.login,
                      color: AppColors.appColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  customTextFormField(
                      width: Get.width / 2,
                      borderRadius: 25,
                      hintText: AppStrings.enterUsernameEmail,
                      borderColor: AppColors.textFieldHintColor,
                      controller: TextEditingController()),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  customTextFormField(
                      borderRadius: 25,
                      obscureText: controller.obSecureText.value,
                      obsecureonTap: () {
                        controller.obSecureText.value =
                            !controller.obSecureText.value;
                      },
                      width: Get.width / 2,
                      isPasswordField: true,
                      hintText: AppStrings.enterYourPassword,
                      borderColor: AppColors.textFieldHintColor,
                      controller: TextEditingController()),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {},
                        child: AppText(
                            text: AppStrings.forgetPassword,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue)),
                  ),
                  Center(
                    child: AppButton(
                      useGradient: false,
                      textColor: AppColors.white,
                      text: AppStrings.login,
                      height: 60.0,
                      width: Get.width,

                      // color: Colors.,
                      radius: 30,
                      onPressed: () {
                        log('==============Redirecting to LoginScreen================>Routes-------->${AppRoutes.login}');
                        // Get.toNamed(AppRoutes.login);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                          text: AppStrings.dontHaveAnAccount,
                          color: AppColors.textFieldHintColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      TextButton(
                        onPressed: () {},
                        child: AppText(
                            text: AppStrings.signup,
                            color: AppColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.0001,
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Aligns the content properly
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.textFieldHintColor, // Divider color
                          thickness: 1.0, // Thickness of the divider
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0), // Space around "OR"
                        child: AppText(text: "OR"),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.textFieldHintColor, // Divider color
                          thickness: 1.0, // Thickness of the divider
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Center(
                    child: AppButton(
                      useGradient: false,
                      color: AppColors.white,
                      hasBorder: true,
                      image: AppImages.google,
                      borderColor: AppColors.textFieldHintColor,
                      textColor: AppColors.appColor,
                      text: AppStrings.loginwithGoogle,

                      height: 60.0,
                      width: Get.width,

                      // color: Colors.,
                      radius: 30,
                      onPressed: () {
                        log('==============Redirecting to LoginScreen================>Routes-------->${AppRoutes.login}');
                        // Get.toNamed(AppRoutes.login);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
