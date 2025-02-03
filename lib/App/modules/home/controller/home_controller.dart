import 'dart:developer';

import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../../Models/Post.dart';
import '../../../service/http_service.dart';
import '../../../utilse/toast_util.dart';

class HomeController extends GetxController {
  RxList<Post> posts = <Post>[].obs; // Original list of posts
  RxList<Post> filteredPosts = <Post>[].obs; // New list for filtered posts

  RxBool isPostLoading = false.obs;

  RxString searchedValue = "".obs;

  RxList<String> Images = [
    "assets/images/img.png",
    "assets/images/img_1.png",
    "assets/images/img_2.png",
    "assets/images/img_3.png"
  ].obs;

  void changeSearchValue(String newValue) {
    searchedValue.value = newValue;
    log("New value is $newValue");
    filterPost();
  }

  void filterPost() {
    String searchQuery = searchedValue.value.toLowerCase();

    // If the search value is not empty, filter the posts
    if (searchQuery.isNotEmpty) {
      var filtered = posts.where((post) {
        log("Post.category is ${post.category}");
        return post.title.toLowerCase().contains(searchQuery) ||
            post.description.toLowerCase().contains(searchQuery);
      }).toList();
      filteredPosts.value = filtered;
    } else {
      // If the search value is empty, show all posts
      filteredPosts.value = posts;
    }
  }

  Future<void> fetchAndAssignPosts() async {
    try {
      isPostLoading.value = true;
      final result = await getPosts();
      posts.value = result;
      filteredPosts.value = posts;
    } catch (e) {
      log("error is $e");
      ToastUtil.showToast(
        message: "Failed to load posts: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    } finally {
      isPostLoading.value = false;
    }
  }

  List<Post> parsePosts(List<dynamic> responseList) {
    return responseList.map<Post>((json) => Post.fromJson(json)).toList();
  }

  Future<List<Post>> getPosts() async {
    try {
      final response = await HttpService.get('/getPosts');
      print(response);
      if (response is List) {
        log("Response is $response");
        return parsePosts(response);
      } else if (response is Map && response['error'] != null) {
        throw Exception(response['error']);
      }
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch posts: ${e.toString()}');
    }
  }

  @override
  void onInit() {
    fetchAndAssignPosts();
    super.onInit();
  }
}
