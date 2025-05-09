import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

class SendOtp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.forgetPassworController;
    final key = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(() => LoadingOverlay(
            isLoading: controller.showLoading.value,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                        key: key,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              SizedBox(
                                height: Get.height * 0.005,
                              ),
                              // AppText(
                              //     text: AppStrings.forgtoPassword,
                              //     color: AppColors.appColor,
                              //     fontSize: 30,
                              //     fontWeight: FontWeight.w500),
                              SizedBox(
                                height: Get.height * 0.04,
                              ),
                              customTextFormField(
                                  validatore: (value) {
                                    return Validators.emailValidator(value!);
                                  },
                                  width: Get.width / 2,
                                  borderRadius: 25,
                                  hintText: AppStrings.enterUsernameEmail,
                                  borderColor: AppColors.textFieldHintColor,
                                  controller: controller.emailController),
                              SizedBox(
                                height: Get.height * 0.4,
                              ),
                              Center(
                                child: AppButton(
                                    useGradient: false,
                                    textColor: AppColors.white,
                                    text: AppStrings.resetPassword,
                                    height: 60.0,
                                    width: Get.width,
                                    radius: 30,
                                    onPressed: () {
                                      if (key.currentState!.validate()) {
                                        controller.sendEmail();
                                      }
                                    }),
                              ),
                            ])))))));
  }
}
