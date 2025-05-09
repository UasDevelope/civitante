import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.forgetPassworController;
    GlobalKey<FormState> newPassword = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(() => LoadingOverlay(
            isLoading: controller.showLoading.value,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                    key: newPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          spacing: 10,
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
                            AppText(
                                text: AppStrings.newPassword,
                                color: AppColors.appColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                            SizedBox(
                              height: Get.height * 0.09,
                            ),
                            customTextFormField(
                                // validatore: (value) {
                                //   return Validators.passwordValidator(value!);
                                // },
                                borderRadius: 25,
                                icon: controller.obsecureText.value
                                    ? Icons
                                        .visibility_off_outlined // Icon for hidden password
                                    : Icons.visibility_outlined,
                                obscureText: controller.obsecureText.value,
                                obsecureonTap: () {
                                  controller.togglePassword();
                                  print(controller.obsecureText.value);
                                },
                                width: Get.width / 2,
                                isPasswordField: true,
                                hintText: AppStrings.enterYourPassword,
                                borderColor: AppColors.textFieldHintColor,
                                controller: controller.newPasswordController),
                            SizedBox(
                              height: Get.height * 0.002,
                            ),
                            customTextFormField(
                                validatore: (value) {
                                  return Validators.confirmPasswordValidator(
                                      value!,
                                      controller.newConfirmPassword.text);
                                },
                                borderRadius: 25,
                                icon: controller.obsecureText.value
                                    ? Icons
                                        .visibility_off_outlined // Icon for hidden password
                                    : Icons.visibility_outlined,
                                obscureText: controller.obsecureText.value,
                                obsecureonTap: () {
                                  controller.togglePassword();
                                },
                                width: Get.width / 2,
                                isPasswordField: true,
                                hintText: AppStrings.reenterPassword,
                                borderColor: AppColors.textFieldHintColor,
                                controller: controller.newConfirmPassword),
                            SizedBox(
                              height: Get.height * 0.2,
                            ),
                            Center(
                              child: AppButton(
                                  useGradient: false,
                                  textColor: AppColors.white,
                                  text: AppStrings.newPassword,
                                  height: 60.0,
                                  width: Get.width,
                                  radius: 30,
                                  onPressed: () {
                                    if (newPassword.currentState!.validate()) {
                                      controller.resetPassword();
                                    }
                                  }),
                            ),
                          ]),
                    ))))));
  }
}
