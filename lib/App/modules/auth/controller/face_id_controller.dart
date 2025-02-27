import 'package:camera/camera.dart';
import 'package:civitante/App/routes/routes.dart';
import 'package:get/get.dart';
import 'dart:async';

class FaceIDController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  XFile? image;
  var isCameraInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras![1], ResolutionPreset.medium);
    await cameraController!.initialize();
    isCameraInitialized.value = true;
    Future.delayed(Duration(seconds: 7), () {
      captureImage();
    });
  }

  Future<void> captureImage() async {
    if (!isCameraInitialized.value || cameraController == null) return;
    try {
      image = await cameraController!.takePicture();
      Get.offAllNamed(AppRoutes.bottomNav);
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
