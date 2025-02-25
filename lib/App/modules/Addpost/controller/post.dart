import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../service/http_service.dart';
import '../../../utilse/constant.dart';
import '../../../utilse/toast_util.dart';
import '../../../utilse/uploadImage.dart';
import '../../home/controller/home_controller.dart';

class PostController extends GetxController {
  RxString selectedLanguage = 'English'.obs;
  RxList<String> languages = ['English', 'Spanish', 'French', 'German'].obs;
  RxString selectCatagory = "General".obs;
  RxList<String> categories =
      ['General', 'Tech', 'Lifestyle', 'Business', 'Health'].obs;
  final TextEditingController tagController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  RxBool isloading = false.obs;

  RxList<String> tags = <String>[].obs;
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

  // Reactive list to hold image URLs (e.g., using GetX, Provider, etc.)

  Future<void> pickImage() async {
    isloading.value = true;
    try {
      final ImagePicker picker = ImagePicker();
      // Pick image from gallery
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Compress the image
        final XFile? compressedImage =
            await ImageUtils.compressImage(pickedFile);

        if (compressedImage != null) {
          // Upload to Firebase Storage
          String imageUrl = await ImageUtils.uploadImageToFirebase(
              File(compressedImage.path));

          // Assign URL to the list (and optionally handle type-specific logic)
          images.add(imageUrl); // Add to general list
          isloading.value = false;
          log("Image uploaded! URL: $imageUrl");
        } else {
          log("Image compression failed.");
        }
      } else {
        log("No image selected.");
      }
    } catch (e) {
      log("Error during image pick/upload: $e");
    }
    isloading.value = false;
  }

  RxString singleImage = ''.obs;
  Future<void> pickSingleImage() async {
    isloading.value = true;
    try {
      final ImagePicker picker = ImagePicker();
      // Pick image from gallery
      final XFile? pickedFile =
      await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Compress the image
        final XFile? compressedImage =
        await ImageUtils.compressImage(pickedFile);

        if (compressedImage != null) {
          // Upload to Firebase Storage
          String imageUrl = await ImageUtils.uploadImageToFirebase(
              File(compressedImage.path));

          // Assign URL to a single variable instead of a list
          singleImage.value = imageUrl;
          isloading.value = false;
          log("Single image uploaded! URL: $imageUrl");
        } else {
          log("Image compression failed.");
        }
      } else {
        log("No image selected.");
      }
    } catch (e) {
      log("Error during image pick/upload: $e");
    }
    isloading.value = false;
  }


  // Method to trigger permission check and image pick
  Future<void> pickImageWithPermission() async {
    await _checkPermissions();
  }

  void addPost({String communityId = ""}) async {
    try {
      isloading.value = true;
      // 1. Validate User ID
      final userID = AppConstant().userID;
      if (userID == null || userID.isEmpty) {
        ToastUtil.showToast(
          message: "User authentication failed. Please login again.",
          backgroundColor: Colors.red,
        );
        return;
      }

      // 2. Validate Required Fields
      if (titleController.text.trim().isEmpty) {
        ToastUtil.showToast(
          message: "Please enter a title",
          backgroundColor: Colors.orange,
        );
        return;
      }

      if (descController.text.trim().isEmpty) {
        ToastUtil.showToast(
          message: "Please enter a description",
          backgroundColor: Colors.orange,
        );
        return;
      }

      if (images.isEmpty) {
        ToastUtil.showToast(
          message: "Please add at least one image",
          backgroundColor: Colors.orange,
        );
        return;
      }

      // CustomLoadingDialog.showCustomLoadingDialog(
      //     "Creating  ${communityId != "" ? "Community " : ""}Post...");

      // 3. Prepare Post Data
      final data = {
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
        "tags": tags.whereType<String>().toList(), // Ensure valid tags
        "category": selectCatagory.value,
        "media": ["image"],
        "mediaUrls":  images,
        "createdBy": userID,
      };

      print('Post Data: $data');

      // 4. Submit to API
      final response = await HttpService.post(
          communityId == "" ? '/addPosts' : '/postInCommunity/$communityId',
          data);

      // 5. Handle Response
      if (response != null && response['error'] == null) {
        final homeController = Get.find<HomeController>();
        homeController.fetchAndAssignPosts();
        ToastUtil.showToast(
          message: response['message'] ?? "Post created successfully!",
          backgroundColor: Colors.green,
        );
        isloading.value = false;
      //  CustomLoadingDialog.closeLoadingDialog();
        final controller = LocateController.homeController;
        controller.fetchAndAssignPosts(communityId: communityId);
        _clearForm();
        Get.back();
      } else {
        isloading.value = false;
        log("Response is $response");
        final errorMessage = _parseErrorMessage(response);
        print("Response of Pints is :$errorMessage");
        if(errorMessage == "Not enough points to create a post")
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.light_gray,
            title: AppText(text: "Dear User",fontWeight: FontWeight.w600),
            content: AppText(text: errorMessage,fontSize: 14),
            actions: [
              AppButton(
                textColor: AppColors.light_gray,
                text: "Buy Now!", onPressed: () {
                Get.to(WalletScreen());
              },)
            ],
          ),
        );

        // ToastUtil.showToast(
        //   message: errorMessage,
        //   backgroundColor: Colors.red,
        // );

      //  CustomLoadingDialog.closeLoadingDialog();
      }
    } catch (e) {
      isloading.value = false;
      log("Error is $e");
      //CustomLoadingDialog.closeLoadingDialog();

      ToastUtil.showToast(
        message: "Network error: Please check your connection",
        backgroundColor: Colors.red,
      );
    } finally {
      // isloading.value = false;
    }
  }

  void _clearForm() {
    titleController.clear();
    descController.clear();
    tags.clear();
    images.clear();
    // Add other field resets if needed
  }

  String _parseErrorMessage(dynamic response) {
    try {
      if (response == null) return "Unknown error occurred";
      if (response['details'] != null) {
        return jsonDecode(response['details'])['message'] ?? "Operation failed";
      }
      return response['message'] ?? "Something went wrong";
    } catch (e) {
      return "Failed to process error message";
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    tagController.dispose();
    super.onClose();
  }
}
