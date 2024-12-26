import 'dart:async';
import 'dart:developer';
import 'package:civitante/App/utilse/widgets.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() {
    try {
      // Using Timer to simulate a delay (3 seconds)
      Timer(Duration(seconds: 3), () {
        // After the timer, redirect to the SplashScreen
        Get.offAllNamed(AppRoutes.started);

        // Log the redirection message
        log("==============Redirecting to SplashScreen================>");
      });
    } catch (e) {
      // Log the error using debugPrint for better error tracking
      debugPrint("Error while redirecting to Splash: $e");
    }
  }
}
