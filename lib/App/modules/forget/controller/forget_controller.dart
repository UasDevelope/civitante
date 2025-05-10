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
      Get.toNamed(AppRoutes.newPassword);
    } finally {
      showLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    var data={
      "email": emailController.text,
      "otp": pinController.value.text,
      "newPassword": newPasswordController.text,
    };
    log(data.toString());
    try {
      showLoading.value = true;
      final response = await HttpService.post(
        "/reset-password",
        data,
      );
      log("Response is $response");
      if (response != null && response['error'] == null) {
        Get.offAllNamed(AppRoutes.login);
        log("Verified");
      }
    } finally {
      showLoading.value = false;
    }
  }
}
