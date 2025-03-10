import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:civitante/App/routes/routes.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/toast_util.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceIDController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  XFile? image;
  var isCameraInitialized = false.obs;
  var countdown = 7.obs; // Countdown seconds
  FlutterTts flutterTts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    // Find the front camera
    final frontCamera = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras!.first, // Fallback to any camera if front is not found
    );

    // Use the front camera
    cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await cameraController!.initialize();

    isCameraInitialized.value = true;
    _startCountdown();
  }


  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (countdown.value == 0) {
        timer.cancel();
        await captureImage();
      } else {
        countdown.value--;
        await _speakCountdown(); // Speak the countdown
      }
    });
  }

  Future<void> _speakCountdown() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.4); // Deep voice
    await flutterTts.setSpeechRate(0.5); // Slower for suspense



    await flutterTts.speak("${countdown.value}");
  }


  Future<void> captureImage() async {
    if (!isCameraInitialized.value || cameraController == null) return;
    try {
      image = await cameraController!.takePicture();
      if (image != null) {
        bool isFaceDetected = await detectFace(File(image!.path));
        if (isFaceDetected) {
          PrefUtil.setString(PrefUtil.isUserFaceAuthCompleted, "true");
          print("Face detected! Navigating to home.");
          Get.offAllNamed(AppRoutes.bottomNav);
        } else {
          ToastUtil.showToast(message: "No face detected! Please try again");
          countdown.value = 7; // Reset countdown
          _startCountdown();
          print("No face detected! Please try again.");
        }
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }
  Future<bool> detectFace(File pickedImage) async {
    final inputImage = InputImage.fromFilePath(pickedImage.path);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableContours: true,
        enableLandmarks: true,
        enableTracking: true,
      ),
    );

    try {
      List<Face> faces = await faceDetector.processImage(inputImage);
      faceDetector.close();
      if (faces.isNotEmpty) {
        print("Face detected successfully");
        return true;
      } else {
        print("No face detected.");
        return false;
      }
    } catch (e) {
      print("Face detection error: $e");
      return false;
    }
  }
  @override
  void onClose() {
    cameraController?.dispose();
    flutterTts.stop();
    super.onClose();
  }
}
