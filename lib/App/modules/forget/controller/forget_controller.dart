import 'dart:developer';

import 'package:civitante/App/utilse/widgets.dart';

class ForgetPassworController extends GetxController {
  final Rx<TextEditingController> pinController = TextEditingController().obs;
  RxBool  obsecureText = RxBool(false);
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPassword = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool showLoading = RxBool(false);
  void togglePassword() {
    obsecureText.value = !obsecureText.value;
    print(obsecureText.value);
  }

  void goToRoute(String routeName) {
    showLoading.value = true;

    Timer(Duration(seconds: 4), () {
      Get.toNamed(routeName);
      log('==============Redirecting to ${routeName}================>Routes-------->${routeName}');

      showLoading.value = false;
    });
  }
}
