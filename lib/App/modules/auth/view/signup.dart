import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../utilse/widgets.dart';
import 'dart:io';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.authController;

    return Obx(() => LoadingOverlay(
        isLoading: controller.loading.value,
        child: Material(
            color: AppColors.white,
            child: SizedBox(
              height: Get.height,
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),

                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: controller.signupGlobalKey,
                      child: Column(

                        spacing: 12,

                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppImages.logo,

                            height: 170,

                            width: 300,
                            fit: BoxFit.contain,
                          ),
                          // SizedBox(
                          //   height: Get.height * 0.0010,
                          // ),
                          // AppText(
                          //     text: AppStrings.signUpPro,
                          //     color: AppColors.appColor,
                          //     fontSize: 30,
                          //     fontWeight: FontWeight.w500),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          customTextFormField(
                              width: Get.width / 2,
                              borderRadius: 25,
                              hintText: AppStrings.enterFullName,
                              borderColor: AppColors.textFieldHintColor,
                              controller: controller.fullNameController),
                          SizedBox(
                            height: Get.height * 0.008,
                          ),
                          customTextFormField(
                              validatore: (value) {
                                return Validators.emailValidator(value!);
                              },
                              width: Get.width / 2,
                              borderRadius: 25,
                              hintText: AppStrings.enterUsernameEmail,
                              borderColor: AppColors.textFieldHintColor,
                              controller: controller.signupEmailController),
                          // SizedBox(
                          //   height: Get.height * 0.008,
                          // ),
                          // customTextFormField(
                          //     validatore: (value) {
                          //       return Validators.locationValidator(value!);
                          //     },
                          //     obsecureonTap: () {
                          //       controller.assignLocationValue();
                          //     },
                          //     width: Get.width / 2,
                          //     icon: Icons.location_on_outlined,
                          //     borderRadius: 25,
                          //     hintText: AppStrings.location,
                          //     borderColor: AppColors.textFieldHintColor,
                          //     controller: controller.signupLocationController),
                          SizedBox(
                            height: Get.height * 0.008,
                          ),
                          customTextFormField(
                              validatore: (value) {

                              },
                              borderRadius: 25,
                              icon: controller.obSecureText.value
                                  ? Icons
                                      .visibility_off_outlined // Icon for hidden password
                                  : Icons
                                      .visibility_outlined, // Icon for visible password                      obscureText: controller.obSecureText.value,
                              obsecureonTap: () {
                                controller.changeObsecure();
                              },
                              width: Get.width / 2,
                              obscureText: controller.obSecureText.value,
                              isPasswordField: true,
                              hintText: AppStrings.enterYourPassword,
                              borderColor: AppColors.textFieldHintColor,
                              controller: controller.signupPasswordController),
                          SizedBox(
                            height: Get.height * 0.008,
                          ),
                          customTextFormField(
                              validatore: (value) {
                                return Validators.confirmPasswordValidator(
                                    value!,
                                    controller.signupPasswordController.text);
                              },
                              borderRadius: 25,
                              icon: controller.obSecureText.value
                                  ? Icons
                                      .visibility_off_outlined // Icon for hidden password
                                  : Icons.visibility_outlined,
                              obscureText: controller.obSecureText.value,
                              obsecureonTap: () {
                                controller.changeObsecure();
                              },
                              width: Get.width / 2,
                              isPasswordField: true,
                              hintText: AppStrings.reenterPassword,
                              borderColor: AppColors.textFieldHintColor,
                              controller:
                                  controller.SignupConfirmPasswordController),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Center(
                            child: AppButton(
                                useGradient: false,
                                textColor: AppColors.white,
                                text: AppStrings.signup,
                                height: 60.0,
                                width: Get.width,
                                radius: 30,
                                onPressed: () {
                                  controller.registerNormalUser();
                                }),
                          ),
                          // SizedBox(
                          //   height: Get.height * 0.005,
                          // ),
                          // Center(
                          //   child: AppButton(
                          //       useGradient: false,
                          //       textColor: AppColors.white,
                          //       text: AppStrings.go,
                          //       height: 60.0,
                          //       width: Get.width,
                          //       radius: 30,
                          //       onPressed: () {
                          //         // if (controller.signupGlobalKey.currentState!
                          //         //     .validate()) {
                          //         controller.goToNext(AppRoutes.proAccound);
                          //         // }
                          //       }),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                  text: AppStrings.alreadyHaveanAccount,
                                  color: AppColors.textFieldHintColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              TextButton(
                                onPressed: () {
                                  controller.goToNext(AppRoutes.login);
                                  controller.signupEmailController.clear();
                                  controller.fullNameController.clear();
                                  controller.signupLocationController.clear();
                                  controller.signupPasswordController.clear();
                                  controller.SignupConfirmPasswordController
                                      .clear();
                                },
                                child: AppText(
                                    text: AppStrings.login,
                                    color: AppColors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.0001,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Aligns the content properly
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors
                                      .textFieldHintColor, // Divider color
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
                                  color: AppColors
                                      .textFieldHintColor, // Divider color
                                  thickness: 1.0, // Thickness of the divider
                                ),
                              ),
                            ],
                          ),
                          if (Platform.isAndroid)
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
                                  controller.signUpWithGoogle();
                                },
                              ),
                            ),
                          if (Platform.isIOS)
                            AppleAuthButton(
                              style: AuthButtonStyle(width: 300, height: 60,buttonColor: AppColors.appColor),
                              text: "Apple Login",
                              onPressed: () {
                                controller.signUpWithApple();
                              },
                            ),
                        ],
                      )),
                ),
              )))),
    );

  }
}
