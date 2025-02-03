import 'dart:async';
import 'dart:developer';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:get/get.dart';
import '../../../utilse/SharedPreferencesHelper.dart';
import '../../../utilse/constant.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() async {
    try {
      Timer(const Duration(seconds: 3), () async {
        final userId = await SharedPreferencesHelper.getUserId();
        AppConstant().userID = userId;
        log("User ID: ${userId}  , ${AppConstant().userID}?? 'null'}");

        if (userId != null && userId.isNotEmpty) {
          // User exists - go to main app
          Get.offAllNamed(AppRoutes.bottomNav);
          log("============== Redirecting to Home ================>");
        } else {
          // No user - go to onboarding
          Get.offAllNamed(AppRoutes.started);
          log("============== Redirecting to Get Started ================>");
        }
      });
    } catch (e) {
      debugPrint("Splash Navigation Error: \$e");
      // Fallback to getStarted screen on error
      Get.offAllNamed(AppRoutes.started);
    }
  }
}
