import 'dart:developer';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/Post.dart';
import '../../../controller/controller_locate.dart';
import '../../loading/custom_loading_dialogue.dart';

class ProfileController extends GetxController {
  final bool currentUser;
  ProfileController(this.currentUser);
  // Reactive state
  final RxList<Post> posts = <Post>[].obs;
  final RxString imageUrl = ''.obs;
  final RxString name = ''.obs;
  final RxInt totalPosts = 0.obs;
  final RxInt followers = 0.obs;
  final RxInt following = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  // Dependencies
  final String userId = PrefUtil.getString(PrefUtil.userId);
  HttpService httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }


  Future<void> editProfile() async {
    int costPrice = int.tryParse(costController.text.trim()) ?? 0;
    Map<String, dynamic> updatedData = {
      "name": nameController.text.trim(),
      "costPoints": costPrice,
      "profileImage": imageUrl.value,
    };
    try {
      isLoading.value = true;
      final response = await HttpService.put("/editProfile/", updatedData);

      if (response is Map && response.containsKey('error')) {
        print("Error: ${response['error']}");
        ToastUtil.showToast(message: "${response['error']}");
      } else {
        ToastUtil.showToast(message: "Profile updated successfully!");
        Get.back();
      }
    } catch (e) {
      print("Exception: $e");
    } finally{
      isLoading.value = false;
    }
  }
  Future<void> _loadInitialData() async {
    await Future.wait([
      fetchAndAssignPosts(),
    ]);
  }


  Future<void> fetchAndAssignPosts() async {
    try {
      isLoading.value = true;
      isError.value = false;
      var response = await HttpService.get('/getProfile');
      print('here is response of profile ${response} ');
      final postsData = response['posts'] as List<dynamic>? ?? [];
      name.value = response['name']?.toString() ?? '';
      imageUrl.value = response['profileImage']?.toString() ?? '';
      log("There is profile image ${imageUrl.value}");

      totalPosts.value = response['totalPosts'] is int
          ? response['totalPosts']
          : (response['totalPosts'] is List
              ? response['totalPosts'].length
              : 0);

      followers.value = response['followers'] is int
          ? response['followers']
          : (response['followers'] is List ? response['followers'].length : 0);

      following.value = response['following'] is int
          ? response['following']
          : (response['following'] is List ? response['following'].length : 0);

      imageUrl.value = response['profileImage']?.toString() ?? '';
      nameController.text = name.value;
      posts.assignAll(_parsePosts(postsData));
    } catch (e, stackTrace) {
      isError.value = true;
      _handleError('Failed to load posts', e, stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  List<Post> _parsePosts(List<dynamic> responseList) {
    try {
      return responseList.map<Post>((json) => Post.fromJson(json)).toList();
    } catch (e, stackTrace) {
      log('Post parsing error', error: e, stackTrace: stackTrace);
      throw const FormatException('Failed to parse posts');
    }
  }

  void _handleError(String message, dynamic error, StackTrace stackTrace) {
    log(message, error: error, stackTrace: stackTrace);
    ToastUtil.showToast(
      message: '$message: ${error.toString()}',
      backgroundColor: Colors.red,
    );
  }
}
