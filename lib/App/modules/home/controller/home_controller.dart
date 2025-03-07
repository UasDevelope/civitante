import 'dart:convert';
import 'dart:developer';

import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../../Models/Post.dart';
import '../../../service/http_service.dart';
import '../../../utilse/pref.dart';
import '../../../utilse/toast_util.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin{

  RxString selectedCommentId = ''.obs;
  late TabController tabController;
  var selectedTabIndex = 0.obs;
  var selectedTabValue = "Following".obs;
  var commentReplyList = <Map<String, String>>[].obs;
  void storeComment(String commentId, String commentText, String userId,String userImage) {
    Map<String, String> commentData = {
      "commentId": commentId,
      "commentText": commentText,
      "userId": userId,
      "userImage":userImage,
    };
    commentReplyList.add(commentData);
    log("Updated Comment List: $commentReplyList");
  }


  void toggleReplyBox(String commentId) {
    if (selectedCommentId.value == commentId) {
      selectedCommentId.value = '';
    } else {
      selectedCommentId.value = commentId;
    }
  }

  RxInt newRate = 0.obs;
  RxMap<String, int> newRates = <String, int>{}.obs; // Store rating per post

  void updateRating(String postId, int rate) {
    newRates[postId] = rate; // Update the rating for a specific post
  }
  RxList<Post> posts = <Post>[].obs; // Original list of posts
  RxList<Post> filteredPosts = <Post>[].obs; // New list for filtered posts
  final TextEditingController commentController = TextEditingController();
  final TextEditingController commentReplyController = TextEditingController();
  RxBool isPostLoading = false.obs;
  RxString selectCatagory = "General".obs;
  RxString selectedCategory = "General".obs;
  RxList<String> categoriesList = ["General","Tech","Lifestyle","Business","Health"].obs;
  RxList<String> categories =
      ['General', 'Tech', 'Lifestyle', 'Business', 'Health'].obs;
  RxString searchedValue = "".obs;
  void filterPostsByCategory() {
    if (selectCatagory.value == "General") {
      filteredPosts.value = filteredPosts; // Show all posts if "General" is selected
    } else {
      filteredPosts.value = filteredPosts
          .where((post) => post.category == selectCatagory.value)
          .toList();
    }
  }

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
  void sortPosts() {
    print('Sorting by Likes and Comments...');
    filteredPosts.value = List.from(filteredPosts.value)
      ..sort((a, b) {
        int likesComparison = b.likesCount.value.compareTo(a.likesCount.value);
        if (likesComparison != 0) {
          return likesComparison;
        }
        return b.commentsCount.value.compareTo(a.commentsCount.value); // Sort by comments if likes are equal
      });
  }



  /// Fetch and assign posts
  Future<void> fetchAndAssignPosts({String communityId = "", bool? followed, bool? randomized }) async {
    try {
      posts.clear();
      filteredPosts.clear();
      // if (communityId != "") {
      //   posts.clear();
      //   filteredPosts.clear();
      //   log("Last community id $communityId");
      // }
      isPostLoading.value = true;
      final result = await getPosts(communityId: communityId,followed: followed,randomized: randomized);

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
      // ToastUtil.showToast(
      //   message: "Failed to load posts: ${e.toString()}",
      //   backgroundColor: Colors.red,
      // );
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
  Future<List<Post>> getPosts({String? communityId, bool? followed, bool? randomized}) async {
    try {
      // Construct the request URL based on priority
      String endpoint = '/getPosts';

      if (communityId != null && communityId.isNotEmpty) {
        endpoint += '/$communityId';
      } else if (followed == true) {
        endpoint += '?followed=true';
      } else if (randomized == true) {
        endpoint += '?randomized=true';
      }

      log("Fetching: $endpoint");

      var response = await HttpService.get(endpoint);
     log("Raw Response: $response");

      // Decode JSON response if it's a string
      if (response is String) {
        response = jsonDecode(response);
      }

      // Ensure response is a valid map and contains either 'posts' or 'error'
      if (response is Map<String, dynamic>) {
        if (response.containsKey('posts') && response['posts'] is List) {
         // log("Parsed Posts: ${response['posts']}");
          return parsePosts(response['posts']);
        }

        if (response.containsKey('error')) {
          throw Exception(response['error']);
        }
      }

      throw Exception('Invalid response format');
    } catch (e) {
      log("Fetch Error: $e");
      throw Exception('Failed to fetch posts: ${e.toString()}');
    }
  }

  Future<void> addComments(String postId, Post post) async {
    String userId = PrefUtil.getString(PrefUtil.userId);
    try {
      var data = {"userId": userId, "text": commentController.text};
      log('Requested data is $data');
      final response = await HttpService.post("/addCommentToPost/$postId", data);

      log("Response for comment is   ${response["comments"].last}");

      final errorMessage = _parseErrorMessage(response);
      print("Response of Pints is :$errorMessage");
      if(errorMessage == "Not enough points to comment"){
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
        commentController.clear();
      }
      else{
        final newComment = Comment(id: response["comments"].last["_id"],
          user: User(
              name: name.value,profileImage: imageUrl.value),
          text: commentController.text,
          createdAt: DateTime.now(), isCommentLikedByUser: false.obs, repliesCount: 0.obs, isEdited: false.obs,
        );

        // Add comment to observable list
        post.comments.add(newComment);

        // Optionally refresh UI immediately
        (post.comments
        as RxList)
            .refresh();
        commentController.clear();
      }

    } catch (e) {
      ToastUtil.showToast(message: "$e", backgroundColor: Colors.red);
    } finally {}
  }
  Future<void> addReplyToComment(String postId, String commentId, Post post,String text) async {
    String userId = PrefUtil.getString(PrefUtil.userId);
    try {
      var data = {"userId": userId, "text": text};
      log('Reply requested data is $data');

      final response = await HttpService.post("/addReplyToComment/$postId/$commentId", data);
      log("Reply response is $response");

      final errorMessage = _parseErrorMessage(response);
      print("Response of Points is: $errorMessage");

      if (errorMessage == "Not enough points to reply") {
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
        commentReplyController.clear();
      }
      else {
        // Create new reply object
        final newReply = Comment(
          id: UniqueKey().toString(),
          user: User(id: userId, name: name.value,
          profileImage: imageUrl.value
          ),
          text: text,
          createdAt: DateTime.now(),
          isCommentLikedByUser: false.obs,
          repliesCount: 0.obs,
          isEdited: false.obs,
        );

        // Find the parent comment and add the reply
        for (var comment in post.comments) {
          if (comment.id == commentId) {
            comment.replies ??= RxList<Comment>(); // Ensure replies list exists
            comment.replies.add(newReply);
            comment.replies.refresh(); // Refresh UI
            comment.repliesCount.value++;
            break;
          }
        }
        commentController.clear();
      }
    } catch (e) {
      ToastUtil.showToast(message: "$e", backgroundColor: Colors.red);
    }
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

        final errorMessage = _parseErrorMessage(response);
        print("Response of Pints is :$errorMessage");
        if(errorMessage == "Not enough points to like this post")
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
        //   message: "Error: $errorMsg",
        //   backgroundColor: Colors.red,
        // );

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
  Future<void> addLikeToComment(String postId, String commentId, int index, int commentIndex) async {
    try {
      var response = await HttpService.post("/addLikeToComment/$postId/$commentId", {});

      print("API Response: $response");

      if (response != null && response['error'] == null) {
        bool isLiked = response["isLike"] ?? false;
        var comment = filteredPosts[index].comments[commentIndex];

        if (comment.isCommentLikedByUser != null) {
          comment.isCommentLikedByUser.value = isLiked;
        } else {
          print("Warning: isCommentLikedByUser is null for comment ID: $commentId");
        }
      } else {
        final errorMessage = _parseErrorMessage(response);
        print("Response Error: $errorMessage");

        if (errorMessage == "Not enough points to like this comment") {
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
      }
    } catch (e, stackTrace) {
      print("Exception: ${e.toString()}");
      print("Stack Trace: $stackTrace");

      ToastUtil.showToast(
        message: "Failed to like comment: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }
  Future<void> addPostRating(String postId, int rating, int index) async {
    print("Rating Submitted: $rating for Post ID: $postId");

    try {
      var body = {
        "rate": rating,
      };
      var response = await HttpService.post(
        "/ratePost/$postId",
        body,
      );

      print("API Response: $response");

      if (response != null && response['error'] == null) {
        int newRating = response["rate"] ?? rating;
        print("New Rating here: $newRating");

        // Ensure rate is reactive (RxInt)
        if (filteredPosts[index].rate == null) {
          filteredPosts[index].rate = RxInt(newRating); // Initialize as RxInt
        } else {
          filteredPosts[index].rate.value = newRating;
        }

        print("Updated Rating: ${filteredPosts[index].rate.value} for Post Index: $index");

        ToastUtil.showToast(
          message: "Rated successfully with: $newRating ⭐",
        );
      } else {
        final errorMessage = _parseErrorMessage(response);
        print("Response Error: $errorMessage");
        ToastUtil.showToast(
          message: "Failed to rate post: $errorMessage",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      ToastUtil.showToast(
        message: "Failed to rate post: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
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
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        if (tabController.index == 0) {
          selectedTabValue.value="Following";
          fetchAndAssignPosts(followed: true);
        } else {
          selectedTabValue.value="Random";
          fetchAndAssignPosts(randomized: true);
        }
        selectedTabIndex.value==tabController.index;
      }});
    fetchAndAssignPosts(followed: true,randomized: false,communityId: '');
    fetchCurrentUser();
    super.onInit();
  }
  RxString name = ''.obs;
  RxString imageUrl = ''.obs;

  Future<void> fetchCurrentUser() async {
    try {
      var response = await HttpService.get('/getProfile');
      print('here is response of profile ${response} ');
      final postsData = response['posts'] as List<dynamic>? ?? [];
      name.value = response['name']?.toString() ?? '';
      imageUrl.value = response['profileImage']?.toString() ?? '';
      log("There is profile image ${imageUrl.value}");

      imageUrl.value = response['profileImage']?.toString() ?? '';
    } catch (e, stackTrace) {
    } finally {

    }
  }
}
