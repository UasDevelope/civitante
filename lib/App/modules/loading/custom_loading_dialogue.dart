import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoadingDialog extends StatelessWidget {
  final String text;

  const CustomLoadingDialog({super.key,  this.text=""});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          // Blurred background effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
            child: Container(
              color: Colors.black.withOpacity(0.1), // Light transparent overlay
            ),
          ),
          Center(
            child: CupertinoActivityIndicator(
              radius: 20, // Spinner size
              color: Colors.white, // Spinner color
            ),
          ),
        ],
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
      Get.dialog(const CustomLoadingDialog(text: ""),
          barrierDismissible: false);
    }
  }
}
