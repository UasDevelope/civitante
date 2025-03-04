import 'package:civitante/App/shared/app_button.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  final OtpController otpController = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            AppText(
                text: "Verify You Email",
                fontWeight: FontWeight.w800,
                fontSize: 21),
            AppText(
                text: "waqasakhtar548@gmail.com",
                fontWeight: FontWeight.w400,
                fontSize: 13),
            SizedBox(
              height: Get.height * 0.1,
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    otpController.otpLength,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: index < otpController.otp.value.length
                                ? Colors.green
                                : Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                          text: index < otpController.otp.value.length
                              ? otpController.otp.value[index]
                              : "",
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )),

            SizedBox(height: 20),
            Obx(() => AppText(
                text: otpController.canResend.value
                    ? "Didn't receive OTP?"
                    : "Resend in ${otpController.secondsRemaining.value}s",
                color: AppColors.red_color)),
            SizedBox(height: 10),
            Obx(() => AppButton(
                width: Get.width * 0.4,
                height: 40,
                color: Colors.black,
                textColor: otpController.canResend.value
                    ? AppColors.white
                    : AppColors.Slate_gray,
                onPressed: otpController.canResend.value
                    ? otpController.resendOtp
                    : null,
                text: "Resend OTP",
                hasBorder: false)),

            SizedBox(height: Get.height * 0.05),
            CustomKeyboard(otpController: otpController),
          ],
        ),
      ),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final OtpController otpController;

  const CustomKeyboard({super.key, required this.otpController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: AppColors.appColor),
          borderRadius: BorderRadius.circular(18)),
      width: Get.width,
      child: Column(
        children: [
          for (var i = 0; i < 3; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (j) {
                int num = i * 3 + j + 1;
                return _buildKey(num.toString());
              }),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKey(""),
              _buildKey("0"),
              _buildKey("⌫", isDelete: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value, {bool isDelete = false}) {
    return GestureDetector(
      onTap: () {
        if (isDelete) {
          otpController.deleteDigit();
        } else if (value.isNotEmpty) {
          otpController.addDigit(value);
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.appColor,
          shape: BoxShape.circle,
        ),
        child: AppText(
            text: value,
            color: AppColors.white,
            fontSize: 21,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
