import 'dart:developer';

import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/widgets.dart';

class ForgetPassworController extends GetxController {
  final Rx<TextEditingController> pinController = TextEditingController().obs;
  RxBool obsecureText = RxBool(false);
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPassword = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool showLoading = RxBool(false);
  void togglePassword() {
    obsecureText.value = !obsecureText.value;
    print(obsecureText.value);
  }

  Future<void> sendEmail() async {
    try {
      showLoading.value = true;
      final response = await HttpService.post(
        "/forgot-password",
        {
          "email": emailController.text,
        },
      );
      log("Response from the user is $response");
      Get.toNamed(AppRoutes.verifyOtp);
    } finally {
      showLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    try {
      showLoading.value = true;
      final response = await HttpService.post(
        "/reset-password",
        {
          "email": emailController.text,
          "otp": pinController.value.text,
          "newPassword": newPasswordController.text,
        },
      );
      log("Response is $response");
      Get.offAllNamed(AppRoutes.login);
    } finally {
      showLoading.value = false;
    }
  }
}
