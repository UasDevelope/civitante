import 'dart:io';
import 'package:flutter/material.dart';
import 'package:civitante/App/utilse/widgets.dart';

class ProAccountScren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.authController;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(() => LoadingOverlay(
            isLoading: controller.loading.value,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
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
                          AppText(
                              text: AppStrings.signUpPro,
                              color: AppColors.appColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                          SizedBox(
                            height: Get.height * 0.001,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                  text: AppStrings.cost,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appColor),
                              AppText(
                                  text: "\$10",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appColor)
                            ],
                          ),
                          customTextFormField(
                              validatore: (value) {
                                return Validators.userNameValidator(value!);
                              },
                              width: Get.width / 2,
                              borderRadius: 25,
                              hintText: AppStrings.Enter_Your_SSN_Number,
                              borderColor: AppColors.textFieldHintColor,
                              controller: controller.ssNumber),
                          SizedBox(
                            height: Get.height * 0.002,
                          ),
                          InkWell(
                            onTap: () {
                              controller.pickImage("1");
                            },
                            child: Container(
                              height: 125,
                              child: controller.drivingLicense.value.isEmpty
                                  ? Image.asset(
                                      AppImages.dotted,
                                    )
                                  : Image.file(File(controller
                                      .drivingLicense.value
                                      .toString())),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.0,
                          ),
                          InkWell(
                            onTap: () {
                              controller.pickImage("2");
                            },
                            child: Container(
                              height: 125,
                              child: controller.passport.value.isEmpty
                                  ? Image.asset(
                                      AppImages.driving,
                                    )
                                  : Image.file(File(controller
                                      .drivingLicense.value
                                      .toString())),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.006,
                          ),
                          Center(
                            child: AppButton(
                                useGradient: false,
                                textColor: AppColors.white,
                                text: AppStrings.submit,
                                height: 60.0,
                                width: Get.width,
                                radius: 30,
                                onPressed: () {
                                  controller.goToNext(AppRoutes.bottomNav);
                                }),
                          ),
                        ]))))));
  }
}
