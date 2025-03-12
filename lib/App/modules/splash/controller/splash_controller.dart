import 'dart:async';
import 'dart:developer';
import 'package:civitante/App/service/auth_services.dart';
import 'package:civitante/App/service/local_auth_service.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
      handleToken();
    } catch (e) {
      debugPrint("Splash Navigation Error: \$e");
      // Fallback to getStarted screen on error
      Get.offAllNamed(AppRoutes.started);
    }
  }

  void handleToken() {
    Timer(const Duration(seconds: 3), () async {
      final token = PrefUtil.getString(PrefUtil.userId);
      final isUserAuth = PrefUtil.getString(PrefUtil.isUserFaceAuthCompleted);

      if (token.isNotEmpty) {
        bool isExpired = JwtDecoder.isExpired(token);
        DateTime expirationDate = JwtDecoder.getExpirationDate(token);
        print("Token Expiration Date: $expirationDate");

        if (isExpired) {
          print("Token has expired, redirecting to login...");
          Get.offAllNamed(AppRoutes.started);
        } else {
          // if (isUserAuth.isEmpty || isUserAuth != "true") {
          //   print("User is not authenticated with FaceAuth, redirecting...");
          //   Get.offAllNamed(AppRoutes.faceIDScreen);
          // } else {
            print("Token is valid, FaceAuth completed, redirecting to home...");
            AppConstant().userID = token;
            Get.offAllNamed(AppRoutes.bottomNav);
          // }
        }
      } else {
        print("No token found, redirecting to login...");
        Get.offAllNamed(AppRoutes.started);
      }
    });
  }
}
