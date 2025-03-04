import 'package:get/get.dart';
import 'dart:async';

class OtpController extends GetxController {
  var otp = ''.obs;
  final int otpLength = 4;

  var secondsRemaining = 120.obs;
  late Timer timer;
  var canResend = false.obs;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    secondsRemaining.value = 120;
    canResend.value = false;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    otp.value = "";
    startTimer();
    // TODO: Call API to resend OTP
  }

  void addDigit(String digit) {
    if (otp.value.length < otpLength) {
      otp.value += digit;
    }
  }

  void deleteDigit() {
    if (otp.value.isNotEmpty) {
      otp.value = otp.value.substring(0, otp.value.length - 1);
    }
  }

  bool isOtpComplete() => otp.value.length == otpLength;
}
