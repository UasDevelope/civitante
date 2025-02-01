import 'dart:convert';

import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../service/http_service.dart';
import '../../../utilse/constant.dart';
import '../../../utilse/toast_util.dart';

class PostController extends GetxController {
  RxString selectedLanguage = 'English'.obs;
  RxList<String> languages = ['English', 'Spanish', 'French', 'German'].obs;
  RxString selectCatagory = "General".obs;
  RxList<String> categories =
      ['General', 'Tech', 'Lifestyle', 'Business', 'Health'].obs;
  final TextEditingController tagController = TextEditingController();
  final titleController = TextEditingController();

  RxList<String> tags = [""].obs;
  var images = <String>[].obs; // Observable list of image paths

  // Method to check and request permission
  Future<void> _checkPermissions() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      await pickImage();
    } else {
      // Show a dialog or notification to inform the user about permission denial
      print("Permission Denied");
    }
  }

  // Method to pick images
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      images.add(pickedFile.path); // Add the picked image path to the list
    }
  }

  // Method to trigger permission check and image pick
  Future<void> pickImageWithPermission() async {
    await _checkPermissions();
  }

  void addPost({
    required String title,
    required String description,
    required List<String> media,
  }) async {
    String? userID = AppConstant().userID;

    if (userID == null) {
      ToastUtil.showToast(
        message: "User ID is not set.",
        backgroundColor: Colors.red,
      );
      return;
    }

    var data = {
      "title": title,
      "description": description,
      "tags": tags,
      "category": selectCatagory.value,
      "media": ["image"],
      "mediaUrls": images,
      "createdBy": userID,
    };

    var response = await HttpService.post('/addPost', data);

    if (response != null && response['error'] == null) {
      ToastUtil.showToast(
        message: response['message'] ?? "Post added successfully!",
        backgroundColor: Colors.green,
      );
    } else {
      String errorMsg = response['details'] != null
          ? jsonDecode(response['details'])['message']
          : "Unknown error occurred";

      ToastUtil.showToast(
        message: "Error: $errorMsg",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    tagController.dispose();
    super.onClose();
  }
}
