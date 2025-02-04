import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:civitante/App/utilse/widgets.dart';

class CustomLoadingDialog extends StatelessWidget {
  final String text;

  const CustomLoadingDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          height: Get.height * 0.25, // Responsive height
          width: Get.width * 0.6, // Responsive width
          decoration: BoxDecoration(
            color:
                AppColors.greyShade, // Used greyShade instead of splashGradient
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.Slate_gray.withOpacity(
                    0.4), // Adjusted shadow color
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(
                color: Colors.grey, // Used AppColors.white
                radius: 20,
              ),
              SizedBox(height: 20),
              DefaultTextStyle(
                style: TextStyle(
                  color: AppColors.appColor, // Adjusted text color
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Close the loading dialog
  static void closeLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Show the loading dialog
  static void showCustomLoadingDialog(String loadingText) {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(CustomLoadingDialog(text: loadingText),
          barrierDismissible: false);
    }
  }
}
