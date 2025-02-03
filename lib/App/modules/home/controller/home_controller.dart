import 'dart:convert';
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
        // log("Post.category is ${post.category}");
        return post.title.toLowerCase().contains(searchQuery) ||
            post.description.toLowerCase().contains(searchQuery);
      }).toList();
      filteredPosts.value = filtered;
    } else {
      // If the search value is empty, show all posts
      filteredPosts.value = posts;
    }
  }

  /// Fetch and assign posts
  Future<void> fetchAndAssignPosts() async {
    try {
      isPostLoading.value = true;
      final result = await getPosts();

      // Ensure the fetched list is not null before assigning
      if (result.isNotEmpty) {
        posts.assignAll(result);
        filteredPosts.assignAll(result);
      } else {
        log("No posts found");
        posts.clear();
        filteredPosts.clear();
      }
    } catch (e) {
      log("Error: $e");
      ToastUtil.showToast(
        message: "Failed to load posts: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    } finally {
      isPostLoading.value = false;
    }
  }

  /// Parse JSON response into a List of Post objects
  List<Post> parsePosts(List<dynamic> responseList) {
    try {
      return responseList.map<Post>((json) => Post.fromJson(json)).toList();
    } catch (e) {
      log("Parsing Error: $e");
      return [];
    }
  }

  /// Fetch posts from API
  Future<List<Post>> getPosts() async {
    try {
      var response = await HttpService.get('/getPosts');
      log("Raw Response: $response");

      // Decode JSON response if it's a string
      if (response is String) {
        response = jsonDecode(response);
      }

      // Check if the response is a valid map with a `posts` list
      if (response is Map<String, dynamic> && response.containsKey('posts')) {
        if (response['posts'] is List) {
          log("Parsed Posts: ${response['posts']}");
          return parsePosts(response['posts']);
        }
      }

      // Handle error messages from the API
      if (response is Map<String, dynamic> && response.containsKey('error')) {
        throw Exception(response['error']);
      }

      // If format is incorrect, throw an error
      throw Exception('Invalid response format');
    } catch (e) {
      log("Fetch Error: $e");
      throw Exception('Failed to fetch posts: ${e.toString()}');
    }
  }

  @override
  void onInit() {
    fetchAndAssignPosts();
    super.onInit();
  }
}
