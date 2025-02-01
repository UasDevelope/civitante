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
                        // spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 50.0, // Adjusted for positioning the arrow
                                left: 15,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();

                                  // Get.back(); // Close the drawer when tapping the arrow
                                },
                                child: Image.asset(
                                  AppImages.arrowback,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            AppImages.logo,
                            height: 150,
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
                                  text: "\$1",
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
                            height: Get.height * 0.009,
                          ),
                          InkWell(
                            onTap: () {
                              controller.pickImage("1");
                            },
                            child: Container(
                              height: 150,
                              width: 400,
                              child: controller.drivingLicense.value.isEmpty
                                  ? Image.asset(
                                      AppImages.dotted,
                                    )
                                  : Image.network(
                                      controller.drivingLicense.value
                                          .toString(),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.009,
                          ),
                          InkWell(
                            onTap: () {
                              controller.pickImage("2");
                            },
                            child: Container(
                              height: 150,
                              width: 400,
                              child: controller.passport.value.isEmpty
                                  ? Image.asset(
                                      AppImages.driving,
                                    )
                                  : Image.network(
                                      controller.passport.toString(),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.009,
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
                                  controller.registerProUser();
                                }),
                          ),
                        ]))))));
  }
}
