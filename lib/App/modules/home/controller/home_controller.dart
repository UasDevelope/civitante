import 'dart:convert';
import 'dart:developer';

import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../../Models/Post.dart';
import '../../../service/http_service.dart';
import '../../../utilse/pref.dart';
import '../../../utilse/toast_util.dart';

class HomeController extends GetxController {
  RxList<Post> posts = <Post>[].obs; // Original list of posts
  RxList<Post> filteredPosts = <Post>[].obs; // New list for filtered posts
  final TextEditingController commentController = TextEditingController();
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

  void sortByLikes() {
    filteredPosts.value = List.from(filteredPosts.value)
      ..sort((a, b) => b.likesCount.value.compareTo(a.likesCount.value));
  }

  void sortByComments() {
    print('Sorting by Comments...');
    filteredPosts.value = List.from(filteredPosts.value)
      ..sort((a, b) => b.commentsCount.value.compareTo(a.commentsCount.value));
  }

  /// Fetch and assign posts
  Future<void> fetchAndAssignPosts({String communityId = ""}) async {
    try {
      if (communityId != "") {
        posts.clear();
        filteredPosts.clear();
        log("Last community id $communityId");
      }
      isPostLoading.value = true;
      final result = await getPosts(communityId: communityId);

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
  Future<List<Post>> getPosts({String communityId = ""}) async {
    try {
      bool isCommunity = communityId != "" ? true : false;
      var response =
          await HttpService.get('/getPosts/${isCommunity ? communityId : ""}');
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

  Future<void> addComments(String postId) async {
    String userId = PrefUtil.getString(PrefUtil.userId);
    try {
      var data = {"userId": userId, "text": commentController.text};
      log('Requested data is $data');
      final response =
          await HttpService.post("/addCommentToPost/$postId", data);

      log("Response is $response");
      commentController.clear();
    } catch (e) {
      ToastUtil.showToast(message: "$e", backgroundColor: Colors.red);
    } finally {}
  }

  Future<int> addLikeToPost(String postId, int index) async {
    try {
      var data = {
        "postId": postId,
      };
      print('here is Data ${data}');
      var response = await HttpService.post('/addLikeToPost', data);

      if (response != null && response['error'] == null) {
        filteredPosts[index].likesCount.value = response['likesCount'] ?? 0;
        filteredPosts[index].isLikedByUser.value =
            response['likedDone'] ?? false;
        print("Post liked successfully: $response");
        return response['likesCount'] ?? 0; // Like added successfully
      } else {
        String errorMsg = response['details'] ?? "Unknown error occurred";
        print("Error adding like: $errorMsg");
        ToastUtil.showToast(
          message: "Error: $errorMsg",
          backgroundColor: Colors.red,
        );

        return 0;
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      ToastUtil.showToast(
        message: "Failed to like post: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      return 0;
    }
  }

  Future<Map<String, dynamic>?> viewPostById(String postId, int index) async {
    try {
      var response = await HttpService.get('/view/$postId');

      if (response != null && response['error'] == null) {
        filteredPosts[index].isViewed.value = true;
        filteredPosts[index].views.value = response['views'];
        print("Post details: $response");
        return response; // Returning the post details
      } else {
        String errorMsg = response['details'] ?? "Unknown error occurred";
        print("Error fetching post: $errorMsg");
        ToastUtil.showToast(
          message: "Error: $errorMsg",
          backgroundColor: Colors.red,
        );
        return null;
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      ToastUtil.showToast(
        message: "Failed to fetch post: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  Future<bool> reportPost(String postId, int index) async {
    try {
      var response = await HttpService.post('/reportPost', {"postId": postId});

      if (response != null && response['error'] == null) {
        filteredPosts[index].isReported.value = response['reported'] ?? false;
        print("Post reported successfully: ${response['reported']}");
        ToastUtil.showToast(
          message: "Post reported successfully",
          backgroundColor: Colors.green,
        );
        return true;
      } else {
        String errorMsg = response['details'] ?? "Unknown error occurred";
        print("Error reporting post: $errorMsg");
        ToastUtil.showToast(
          message: "Error: $errorMsg",
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      ToastUtil.showToast(
        message: "Failed to report post: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  @override
  void onInit() {
    fetchAndAssignPosts();
    super.onInit();
  }
}
