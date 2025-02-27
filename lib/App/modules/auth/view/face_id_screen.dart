import 'dart:math';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../controller/face_id_controller.dart';

class FaceIDScreen extends StatelessWidget {
  final FaceIDController controller = Get.put(FaceIDController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Center(
        child: Obx(() {
          return controller.isCameraInitialized.value
              ? Stack(
            alignment: Alignment.center,
            children: [
              CameraPreview(controller.cameraController!), // Camera Feed
              CustomPaint(
                painter: DottedOvalPainter(),
              ),
              Positioned(
                  bottom: 50,
                  child: AppText(text: "Face inside the oval",color: AppColors.light_gray))
            ],
          )
              : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}

class DottedOvalPainter extends CustomPainter {
  final double widthRadius;
  final double heightRadius;
  final double dotSize;
  final double gap;

  DottedOvalPainter({this.widthRadius = 100, this.heightRadius = 140, this.dotSize = 4, this.gap = 10});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;

    double angle = 0;
    double step = (2 * pi) / ((2 * pi * max(widthRadius, heightRadius)) / (dotSize + gap));

    while (angle < 2 * pi) {
      double x = widthRadius * cos(angle) + size.width / 2;  // Adjust X position
      double y = heightRadius * sin(angle) + size.height / 2; // Adjust Y position
      canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      angle += step;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


