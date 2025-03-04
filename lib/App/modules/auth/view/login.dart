import 'dart:developer';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_recaptcha_v2/flutter_easy_recaptcha_v2.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../shared/validators.dart';
import '../../../utilse/widgets.dart';
import 'dart:io';
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  GlobalKey<FormState> loginGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.authController;
    LocateController.locationController;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => LoadingOverlay(
          isLoading: controller.loading.value,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Form(
                      key: loginGlobalKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Image.asset(
                            AppImages.logo,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          AppText(
                              text: AppStrings.login,
                              color: AppColors.appColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          customTextFormField(
                              validatore: (value) {
                                return Validators.emailValidator(value!);
                              },
                              width: Get.width / 2,
                              borderRadius: 25,
                              hintText: AppStrings.enterUsernameEmail,
                              borderColor: AppColors.textFieldHintColor,
                              controller: controller.loginEmailController),
                          customTextFormField(
                              // validatore: (value) {
                              //   return Validators.passwordValidator(value!);
                              // },
                              borderRadius: 25,
                              obscureText: controller.obSecureText.value,
                              obsecureonTap: () {
                                controller.changeObsecure();
                              },
                              width: Get.width / 2,
                              isPasswordField: true,
                              hintText: AppStrings.enterYourPassword,
                              borderColor: AppColors.textFieldHintColor,
                              controller: controller.loginPassworedController),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () {
                                  controller.goToNext(AppRoutes.forgetPassword);
                                  controller.loginEmailController.clear();
                                  controller.loginPassworedController.clear();
                                },
                                child: AppText(
                                    text: AppStrings.forgetPassword,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue)),
                          ),

                          Row(
                            children: [
                              Obx(() => Checkbox(
                                  activeColor: AppColors.blue,
                                  value: controller.isRememberMeChecked.value, onChanged: controller.toggleRememberMe)),
                              AppText(text: "Remember me")
                            ],
                          ),
                          SizedBox(
                            height: 80,
                            child: RecaptchaV2(
                              apiKey: "6Ldqv9sqAAAAAGUMIuQcWL-1WSySnEq_S6I66YbZ",
                              onVerifiedSuccessfully: (token) async {
                                log("Recaptcha token $token");
                                final bool isTokenVerified = await verifyRecaptchaV2Token(
                                  token: token,
                                  apiSecret: "6Ldqv9sqAAAAACQSGDktRo0Ur0X6TNnkhk71phoh",
                                );
                                if (isTokenVerified) {
                                  log("Token verified successfully");
                                } else {
                                  log("Token verification failed");
                                }
                              },
                            ),
                          ),
                          Center(
                            child: AppButton(
                              useGradient: false,
                              textColor: AppColors.white,
                              text: AppStrings.login,
                              height: 60.0,
                              width: Get.width,
                              radius: 30,
                              onPressed: () {
                                if (loginGlobalKey.currentState!.validate()) {
                                  controller.loginUser();
                                }
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
                              SizedBox(
                                width: 14,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.goToNext(AppRoutes.signup);
                                  controller.loginEmailController.clear();
                                  controller.loginPassworedController.clear();
                                },
                                child: AppText(
                                    text: AppStrings.signup,
                                    color: AppColors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Aligns the content properly
                            children: [
                              Expanded(
                                child: Divider(
                                  color:
                                  AppColors.textFieldHintColor, // Divider color
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
                                  color:
                                  AppColors.textFieldHintColor, // Divider color
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
                                  controller.loginWithGoogle();
                                  // Get.toNamed(AppRoutes.login);
                                },
                              ),
                            ),
                          // if (Platform.isIOS)
                          // AppleAuthButton(
                          //   style: AuthButtonStyle(width: 300,height: 50,buttonColor: AppColors.appColor),
                          //   text: "Apple Login",
                          //   onPressed: (){
                          //     controller.loginWithApple();
                          //   },
                          // )

                        ],
                      )),
                  // for (int i = 0; i < controller.tooltipMessages.length; i++)
                  //   Obx(() => CustomTooltip(
                  //     message: controller.tooltipMessages[i],
                  //     isVisible: controller.currentTooltipIndex.value == i,
                  //     onNSkip: controller.skipTooltips,
                  //     onNext: controller.nextTooltip,
                  //     child: SizedBox(),
                  //   )),
                ],
              ),
            ),
          ))),
    );
  }
}

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final bool isVisible;
  final VoidCallback? onNext;
  final VoidCallback? onNSkip;

  const CustomTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.isVisible = false,
    this.onNext, this.onNSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isVisible)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: Get.height* 0.20),
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.light_gray,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  ),
                  child: AppText(
                      text: message,
                      color: AppColors.Slate_gray
                  ),
                ),
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onNSkip,
                      child: Container(
                        padding:EdgeInsets.symmetric(vertical: 4,horizontal: 6),
                        decoration:BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8))

                        ),
                        child: AppText(text: "Skip",fontSize: 14,color: AppColors.white),
                      ),

                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: onNext,
                      child: Container(
                        padding:EdgeInsets.symmetric(vertical: 4,horizontal: 6),
                        decoration:BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8))


                        ),
                        child: AppText(text: "Next",fontSize: 14,color: AppColors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        child,

      ],
    );
  }
}

