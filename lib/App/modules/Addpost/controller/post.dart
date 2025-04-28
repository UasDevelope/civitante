import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:civitante/App/modules/profile/controller/profile_controller.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../../service/http_service.dart';
import '../../../utilse/constant.dart';
import '../../../utilse/toast_util.dart';
import '../../../utilse/uploadImage.dart';
import '../../home/controller/home_controller.dart';

class PostController extends GetxController {
  RxString selectedLanguage = 'English'.obs;
  RxList<String> languages = ['English', 'Spanish', 'French', 'German'].obs;
  RxString selectCatagory = "Technology & Innovation".obs;
  RxList<String> categories = [
    'Technology & Innovation',
    'Business & Finance',
    'General & Entertainment',
    'Health & Wellness',
    'Science & Education',
    'Lifestyle & Self-Improvement',
    'Politics & Society',
    'Sports & Recreation',
    'Art & Creativity',
    'Food & Culinary',
    'Automotive & Transport',
    'Work & Careers',
    'DIY & Home Improvement',
    'Relationships & Social Life',
    'Animals & Nature'
  ].obs;
  RxString visibility = ''.obs;

  final TextEditingController tagController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  RxBool isloading = false.obs;
  RxList<String> videos = <String>[].obs; // Observable list for video URLs
  RxString selectedVideo = ''.obs; // For single video preview
  VideoPlayerController? videoPlayerController; // For video preview

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

  Future<void> _checkVideoPermissions() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await pickVideo();
    } else {
      ToastUtil.showToast(
        message: "Storage permission denied",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> pickVideo() async {
    isloading.value = true;
    try {
      // Ensure user is authenticated
      if (AppConstant().userID == null || AppConstant().userID!.isEmpty) {
        ToastUtil.showToast(
          message: "Please sign in to upload videos",
          backgroundColor: Colors.red,
        );
        isloading.value = false;
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 10), // Limit video duration
      );

      if (pickedFile != null) {
        // Generate thumbnail for the video
        final thumbnailXFile = await VideoThumbnail.thumbnailFile(
          video: pickedFile.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 1280,
          quality: 75,
        );

        if (thumbnailXFile.path.isNotEmpty &&
            await File(thumbnailXFile.path).exists()) {
          // Upload video and thumbnail to Cloudinary
          String mediaUrl = await ImageUtils.uploadMediaWithThumbnail(
            thumbnailXFile.path, // Thumbnail path
            pickedFile.path, // Video path
            'HereNow/Videos', // Folder name
          );

          if (mediaUrl.isNotEmpty) {
            videos.add(mediaUrl); // Add combined URL to video list
            selectedVideo.value = mediaUrl; // For preview
            log("Video and thumbnail uploaded! URL: $mediaUrl");
          } else {
            log("Video and thumbnail upload failed.");
            ToastUtil.showToast(
              message: "Failed to upload video and thumbnail",
              backgroundColor: Colors.red,
            );
          }
        } else {
          log("Failed to generate video thumbnail.");
          ToastUtil.showToast(
            message: "Failed to generate video thumbnail",
            backgroundColor: Colors.red,
          );
        }
      } else {
        log("No video selected.");
        ToastUtil.showToast(
          message: "No video selected",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      log("Error during video pick/upload: $e");
      ToastUtil.showToast(
        message: "Failed to upload video: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      isloading.value = false;
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
      final profileController = ProfileController(true);
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

      if (images.isEmpty && videos.isEmpty) {
        ToastUtil.showToast(
          message: "Please add at least one image or video",
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
        "media": [
          if (images.isNotEmpty) "image",
          if (videos.isNotEmpty) "video"
        ],
        "visibility": visibility.value.toLowerCase(),
        "mediaUrls": [...images, ...videos],
        "createdBy": userID,
      };

      print('Post Data: $data');

      // 4. Submit to API
      final response = await HttpService.post(
          communityId == "" ? '/addPosts' : '/postInCommunity/$communityId',
          data);
      print("Response data ==>$response");

      // 5. Handle Response
      if (response != null && response['error'] == null) {
        final homeController = Get.find<HomeController>();

        if (communityId == "") {
          log("Fetching random posts...");
          profileController.fetchAndAssignPosts();
          homeController.fetchAndAssignPosts();
          final bottomNavController = LocateController.bottomNaveController;
          bottomNavController.currentIndex.value = 4;
        } else {
          log("Fetching community post");
          homeController.fetchAndAssignPosts(communityId: communityId);
        }
        ToastUtil.showToast(
          message: response['message'] ?? "Post created successfully!",
          backgroundColor: Colors.green,
        );

        isloading.value = false;
        //  CustomLoadingDialog.closeLoadingDialog();
        _clearForm();
        Get.back();
      } else {
        isloading.value = false;
        log("Response is $response");
        final errorMessage = _parseErrorMessage(response);
        print("Response of Pints is :$errorMessage");
        if (errorMessage == "Not enough points to create a post") {
          Get.dialog(
            AlertDialog(
              backgroundColor: AppColors.light_gray,
              title: AppText(text: "Dear User", fontWeight: FontWeight.w600),
              content: AppText(text: errorMessage, fontSize: 14),
              actions: [
                AppButton(
                  textColor: AppColors.light_gray,
                  text: "Buy Now!",
                  onPressed: () {
                    Get.to(WalletScreen());
                  },
                )
              ],
            ),
          );
        }

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
      isloading.value = false;
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
