import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/pin_input.dart';

class VerifyOtp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.forgetPassworController;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(() => LoadingOverlay(
            isLoading: controller.showLoading.value,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                      child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Get.height / 14,
                            ),
                            Image.asset(
                              AppImages.logo,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: Get.height * 0.001,
                            ),
                            AppText(
                                text: AppStrings.verifyCode,
                                color: AppColors.appColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                            SizedBox(
                              height: Get.height * 0.07,
                            ),
                            Obx(
                              () => CustomPinInput(
                                controller: controller.pinController.value,
                                length: 6,
                                onCompleted: (pin) {
                                  Get.offNamed(AppRoutes.newPassword);
                                  // controller.goToRoute(AppRoutes.newPassword);
                                  // print("Entered PIN: $pin");
                                },
                                defaultBorderColor: Colors.blue,
                                focusedBorderColor: Colors.green,
                                submittedBorderColor: Colors.grey,
                                cursorColor: Colors.red,
                                width: 50,
                                height: 60,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.3,
                            ),
                          ]),
                    ))))));
  }
}
