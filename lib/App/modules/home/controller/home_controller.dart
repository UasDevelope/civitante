import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../../Models/Post.dart';
import '../../../service/http_service.dart';
import '../../../utilse/toast_util.dart';

class HomeController extends GetxController {
  RxList<Post> posts = <Post>[].obs;

  RxList<String> Images = [
    "assets/images/img.png",
    "assets/images/img_1.png",
    "assets/images/img_2.png",
    "assets/images/img_3.png"
  ].obs;

  @override
  void onInit() {
    fetchAndAssignPosts();
    super.onInit();
  }

  Future<void> fetchAndAssignPosts() async {
    try {
      final result = await getPosts();
      posts.value = result; // Assign to observable list
      print(posts.value.length);
    } catch (e) {
      ToastUtil.showToast(
        message: "Failed to load posts: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  List<Post> parsePosts(List<dynamic> responseList) {
    return responseList.map<Post>((json) => Post.fromJson(json)).toList();
  }

  Future<List<Post>> getPosts() async {
    try {
      final response = await HttpService.get('/getPosts');

      if (response is List) {
        return parsePosts(response);
      } else if (response is Map && response['error'] != null) {
        throw Exception(response['error']);
      }
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch posts: ${e.toString()}');
    }
  }
}
