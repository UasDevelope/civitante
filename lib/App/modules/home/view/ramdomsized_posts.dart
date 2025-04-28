import 'dart:developer';

import 'package:civitante/App/modules/home/widgets/filter_menues.dart';
import 'package:civitante/App/modules/loading/empty_data.dart';
import 'package:civitante/App/modules/previewUserProfile/view/previewprofile.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../Models/Post.dart';
import '../../shimmer/randomized_shimmer_post.dart';
import '../../video/view/video_player_view.dart';
import '../controller/home_controller.dart';
import '../widgets/dashed_line_painter.dart';
import '../widgets/engament_row.dart';
import '../widgets/home_search.dart';
import '../widgets/slider_label.dart';

class RandomSizedPostsScreen extends StatefulWidget {
  final String communityId;
  final bool explore;
  final bool? followed;
  final bool? randomized;
  final bool isShowFilter;
  final bool isCommunityDetails;

  const RandomSizedPostsScreen(
      {super.key,
      this.communityId = "",
      this.explore = false,
      this.followed = false,
      this.isShowFilter = true,
      this.randomized = false,
      this.isCommunityDetails = false});

  @override
  State<RandomSizedPostsScreen> createState() => _RandomSizedPostsScreenState();
}

class _RandomSizedPostsScreenState extends State<RandomSizedPostsScreen> {
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    homeController.fetchAndAssignPosts(
        communityId: widget.communityId,
        randomized: widget.randomized,
        followed: widget.followed);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            if (widget.explore == true)
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: HomeSerchField(
                  hintText: "Search here...", // Custom hint text
                  onChanged: (value) {
                    homeController.changeSearchValue(value);
                  },
                ),
              ),
            if (widget.explore == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //         color: Colors.grey, width: 1), // Border
                  //     borderRadius:
                  //     BorderRadius.circular(15), // Rounded corners
                  //   ),
                  //   child: DropdownButton<String>(
                  //     hint: const Text(
                  //         "Select a category"), // Display hint text when no value is selected
                  //     value: homeController.selectCatagory
                  //         .value, // Bind this to a variable in your state
                  //     items: homeController.categories.map((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //     onChanged: (String? value) {
                  //       if (value != null) {
                  //         homeController.selectCatagory.value = value;
                  //         homeController.filterPostsByCategory();
                  //       }
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 10,),
                  if (widget.isShowFilter)
                    HomeFilterMenues(
                      onSelected: (value) {
                        if (value == 'Comments') {
                          homeController.sortByComments();
                        } else {
                          homeController.sortPosts();
                        }
                        print("selected=>$value");
                      },
                    ),
                ],
              ),
            if (widget.explore == false)
              Expanded(
                child: RefreshIndicator(
                    color: AppColors.appColor,
                    onRefresh: () async {
                      await homeController.fetchAndAssignPosts(
                          communityId: widget.communityId,
                          randomized: widget.randomized,
                          followed: widget.followed);
                    },
                    child: Obx(() {
                      if (homeController.isPostLoading.value) {
                        return RandomizedShimmerPost(
                          count: 1,
                        );
                      } else if (homeController.filteredPosts.isEmpty) {
                        return LottieAnimationWidget();
                      } else {
                        return CardSwiper(
                            padding: EdgeInsets.only(bottom: 14),
                            cardsCount: homeController.filteredPosts.length,
                            numberOfCardsDisplayed: 1,
                            threshold:
                                20, // Increased threshold to reduce accidental swipes
                            duration: const Duration(milliseconds: 300),
                            isLoop: false,
                            onSwipe: (previousIndex, currentIndex, direction) {
                              int lastIndex =
                                  homeController.filteredPosts.length - 1;

                              print(
                                  "🔄 Swipe detected. Previous index: $previousIndex, Current index: $currentIndex, Last index: $lastIndex");
                              print("➡️ Swipe direction: $direction");

                              if (direction == CardSwiperDirection.left) {
                                if (previousIndex > 0) {
                                  int targetIndex =
                                      homeController.currentIndex.value - 1;
                                  homeController.changeIndex(targetIndex);
                                  final previousPost =
                                      homeController.filteredPosts[targetIndex];
                                  // Call viewPostById but don't expect it to return anything
                                  homeController.viewPostById(
                                      previousPost.id, targetIndex);

                                  print(
                                      "✅ Swiped left: Navigated to previous post ID: ${previousPost.id}, New index: $targetIndex ad current index is $currentIndex");
                                  return true;
                                } else {
                                  print("❌ Already at the first post.");
                                  return false;
                                }
                              }

                              if (direction == CardSwiperDirection.right) {
                                if (previousIndex < lastIndex) {
                                  int targetIndex =
                                      homeController.currentIndex.value + 1;
                                  homeController.changeIndex(targetIndex);
                                  final nextPost =
                                      homeController.filteredPosts[targetIndex];

                                  // Call viewPostById but don't expect it to return anything
                                  homeController.viewPostById(
                                      nextPost.id, targetIndex);

                                  print(
                                      "✅ Swiped right: Navigated to next post ID: ${nextPost.id}, New index: $targetIndex ad current index is $currentIndex");
                                  return true;
                                } else {
                                  print("🔄 Looping back to first post.");
                                  homeController.fetchAndAssignPosts(
                                      followed:
                                          homeController.isFollowing.value,
                                      randomized:
                                          !homeController.isFollowing.value);
                                  return true;
                                }
                              }

                              return false;
                            },
                            cardBuilder: (context, index, percentThresholdX,
                                percentThresholdY) {
                              print("🛠️ Building card for index: $index");

                              // Validate index to prevent out-of-range errors
                              if (index < 0 ||
                                  index >=
                                      homeController.filteredPosts.length) {
                                print("⚠️ Index out of range: $index");
                                return const SizedBox.shrink();
                              }

                              // Ensure correct post is being displayed

                              return Obx(() {
                                final post = homeController.filteredPosts[
                                    homeController.currentIndex.value];
                                print(
                                    "📄 Correcting Post Display: Expected Index: ${index} Actual Index: ${homeController.currentIndex.value}, Post ID: ${post.id}, Title: ${post.title}");
                                return GestureDetector(
                                  onTap: () {
                                    homeController.viewPostById(post.id, index);

                                    Get.toNamed(AppRoutes.postDetail,
                                        arguments: {
                                          "data": post,
                                          "currentUser": false,
                                        });
                                  },
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: CustomCard2(
                                      key: ValueKey(post.id),
                                      isCommunityDetails:
                                          widget.isCommunityDetails,
                                      haveDescAndTags: false,
                                      post: post,
                                      index: index,
                                    ),
                                  ),
                                );
                              });
                            });
                      }
                    })
                    // child: Obx(() {
                    //   if (homeController.isPostLoading.value) {
                    //     return RandomizedShimmerPost(); // Show shimmer loading effect
                    //   }
                    //   // For empty posts
                    //   else if (homeController.filteredPosts.isEmpty) {
                    //     return LottieAnimationWidget(); // Show empty state animation
                    //   } else {
                    //     return PageView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: homeController.filteredPosts.length,
                    //       controller: PageController(viewportFraction: 1), // Adjust viewport fraction as needed
                    //       onPageChanged: (index) {
                    //         // Handle page change (e.g., update the current post)
                    //         if (index >= homeController.filteredPosts.length) {
                    //           return; // Prevent out-of-bounds access
                    //         }
                    //         final post = homeController.filteredPosts[index];
                    //         homeController.viewPostById(post.id, index);
                    //         print('Swiped to Post: ${post.id} at index: $index');
                    //       },
                    //       itemBuilder: (context, index) {
                    //         if (index >= homeController.filteredPosts.length) {
                    //           return const SizedBox.shrink(); // Return an empty widget if the index is out of bounds
                    //         }
                    //         final post = homeController.filteredPosts[index];
                    //         return GestureDetector(
                    //           onTap: () {
                    //             Get.toNamed(AppRoutes.postDetail, arguments: {
                    //               "data": post,
                    //               "currentUser": false,
                    //             });
                    //           },
                    //           child: CustomCard2(
                    //             haveDescAndTags: false,
                    //             post: post,
                    //             index: index,
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   }
                    // }),
                    ),
              ),
            if (widget.explore == true) ...[
              SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Set a fixed height for the horizontal ListView
                  double height = 38.0; // Adjust based on your item height

                  return SizedBox(
                    height: height, // Fixed height for horizontal scrolling
                    child: ListView.builder(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      physics: BouncingScrollPhysics(),
                      itemCount: homeController.categoriesList.length,
                      itemBuilder: (context, index) {
                        final category = homeController.categoriesList[index];
                        return Obx(() {
                          final isSelected =
                              homeController.selectedCategory.value == category;

                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0), // Horizontal spacing
                            child: InkWell(
                              onTap: () {
                                homeController.selectedCategory.value =
                                    category;
                                print("Selected Category: $category");
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.Slate_gray
                                      : AppColors.light_gray,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: AppText(
                                  text: category,
                                  fontSize: 13,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
            ],
            if (widget.explore == true)
              RefreshIndicator(
                color: AppColors.appColor,
                onRefresh: () async {
                  // Call your refresh method from the controller
                  await homeController.fetchAndAssignPosts(
                      communityId: widget.communityId,
                      randomized: widget.randomized,
                      followed: widget.followed);
                },
                child: Obx(() {
                  if (homeController.isPostLoading.value) {
                    return RandomizedShimmerPost(
                      count: 3,
                    );
                  }
                  //For the empty post
                  else if (homeController.filteredPosts.isEmpty) {
                    return LottieAnimationWidget();
                  } else {
                    return Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: homeController.filteredPosts
                            .where((post) =>
                                post.category ==
                                homeController.selectedCategory.value)
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          final filteredPosts = homeController.filteredPosts
                              .where((post) =>
                                  post.category ==
                                  homeController.selectedCategory.value)
                              .toList();

                          final post = filteredPosts[index];

                          return GestureDetector(
                            onTap: () {
                              var response =
                                  homeController.viewPostById(post.id, index);
                              print('Here is value: ${response}');
                              log("hhhjjknnk...");

                              Get.toNamed(AppRoutes.postDetail, arguments: {
                                "data": post,
                                "currentUser": false
                              });
                            },
                            child: CustomCard2(
                              isCommunityDetails: widget.isCommunityDetails,
                              haveDescAndTags: false,
                              post: post,
                              index: index,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomCard2 extends StatefulWidget {
  CustomCard2(
      {super.key,
      this.haveComments = false,
      required this.post,
      this.currentUser = false,
      this.index = 0,
      required this.haveDescAndTags,
      this.topTitle = true,
      this.isCommunityDetails = false});

  final bool haveComments;
  final bool isCommunityDetails;
  final Post post;
  final bool haveDescAndTags;
  final bool topTitle;
  bool currentUser;
  int index;

  @override
  State<CustomCard2> createState() => _CustomCard2State();
}

class _CustomCard2State extends State<CustomCard2> {
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    log("Video url is ${widget.post.mediaUrls}");
    return Obx(() => Card(
          color: AppColors.white,
          // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Get.to(PreviewProfileScreen(
                        id: widget.post.createdBy.id,
                      ));
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          widget.post.createdBy.profileImage.isNotEmpty
                              ? NetworkImage(
                                  widget.post.createdBy.profileImage.toString())
                              : AssetImage(AppImages.person
                                  .toString()), // Replace with your image
                    ),
                  ),
                  title: InkWell(
                    onTap: () {
                      Get.to(PreviewProfileScreen(
                        id: widget.post.createdBy.id,
                      ));
                    },
                    child: AppText(
                        text: widget.post.createdBy.name.toString(),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  trailing: widget.index >= 0 &&
                          widget.index < homeController.filteredPosts.length &&
                          homeController.filteredPosts[widget.index].isReported
                                  .value !=
                              true
                      ? PopupMenuButton(
                          icon: Image.asset(
                            AppImages.menue,
                            height: 30,
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: AppColors.textFieldHintColor,
                              width: 0.4,
                            ),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: AppText(
                                text: AppStrings.Report,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              onTap: () async {
                                final result = await homeController.reportPost(
                                    widget.post.id, widget.index);
                                if (widget.index <
                                    homeController.filteredPosts.length) {
                                  homeController.filteredPosts[widget.index]
                                      .isReported.value = result;
                                }
                              },
                            ),
                            PopupMenuItem(
                              child: AppText(
                                text: "Block",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              onTap: () async {
                                if (widget.index <
                                    homeController.filteredPosts.length) {
                                  await HttpService.post(
                                      "/blockPost/${homeController.filteredPosts[widget.index].id}",
                                      {});
                                }
                                Get.back();
                                log("Block Button Click");
                              },
                            ),
                          ],
                        )
                      : AppText(
                          text: AppStrings.Reported,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.topTitle
                          ? AppText(
                              OneLine: true,
                              text: widget.post.title,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
                SizedBox(
                  height: widget.topTitle
                      ? widget.isCommunityDetails
                          ? Get.height * 0.25
                          : Get.height * 0.388
                      : 600,
                  child: Stack(
                    children: [
                      widget.haveDescAndTags
                          ? PageView.builder(
                              itemCount: widget.post.mediaUrls.length,
                              itemBuilder: (context, index) {
                                final data = widget.post.mediaUrls[index];
                                final isVideo = data.contains('&thumbnail=');
                                final displayImage = isVideo
                                    ? data.split('&thumbnail=')[1]
                                    : data;
                                final videoUrl =
                                    isVideo ? data.split('&thumbnail=')[0] : '';

                                return GestureDetector(
                                  onTap: () {
                                    if (isVideo) {
                                      Get.to(VideoPlayerScreen(
                                        url: videoUrl,
                                      ));
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                        displayImage,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.error),
                                      ),
                                      if (isVideo)
                                        const Icon(
                                          Icons.play_circle_fill_rounded,
                                          size: 64,
                                          color: Colors.white70,
                                        ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : (() {
                              final firstUrl = widget.post.mediaUrls.isNotEmpty
                                  ? widget.post.mediaUrls.first
                                  : '';
                              final isVideo = firstUrl.contains('&thumbnail=');
                              final displayImage = isVideo
                                  ? firstUrl.split('&thumbnail=')[1]
                                  : firstUrl;

                              return Image.network(
                                displayImage,
                                fit: BoxFit.fitWidth,
                                width: Get.width,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              );
                            })(),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          children: [
                            Obx(() => GestureDetector(
                                  onTap: () {
                                    log("Printed image");
                                  },
                                  child: buildStatItem(
                                    icon: Image.asset(
                                      AppImages.view,
                                      height: 25,
                                      color: widget.post.isViewed.value == true
                                          ? AppColors.green
                                          : AppColors.white,
                                    ),
                                    label: widget.post.views.toString(),
                                    textColor: AppColors.blue,
                                  ),
                                )),
                            const SizedBox(width: 10),
                            Obx(() {
                              return GestureDetector(
                                onTap: () async {
                                  // Use `await` to make sure the like count updates correctly
                                  if (widget.currentUser == false) {
                                    log("Index is ${widget.index} and post id is ${widget.post.id}");
                                    int newLikesCount =
                                        await homeController.addLikeToPost(
                                            widget.post.id, widget.index);
                                  }

                                  // widget.post.likesCount.value =
                                  //     newLikesCount; // Update likesCount reactively
                                },
                                child: buildStatItem(
                                  icon: Image.asset(
                                    AppImages.like,
                                    height: 25,
                                    color: widget.post.isLikedByUser.value
                                        ? AppColors.appColor
                                        : AppColors.white, // Use .value
                                  ),
                                  label: widget.post.likesCount
                                      .toString(), // Use .value
                                  textColor: AppColors.blue,
                                ),
                              );
                            }),
                            const SizedBox(width: 10),
                            buildStatItem(
                              icon: Image.asset(
                                AppImages.comment,
                                height: 25,
                                color: AppColors.white,
                              ),
                              label: widget.post.commentsCount.toString(),
                              // label: post.comments.length.toString(),
                              textColor: AppColors.blue,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: Get.height * 0.05,
                    child: SliderWithLabels(
                      index: widget.index,
                      post: widget.post,
                    )),
                SizedBox(
                  height: 15,
                ),
                widget.haveDescAndTags
                    ? Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 10, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            !widget.topTitle
                                ? AppText(
                                    text: widget.post.title,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )
                                : SizedBox.shrink(),
                            AppText(
                              text: widget.post.description,
                              fontSize: 16,
                              color: AppColors.Slate_gray,
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: widget.post.tags
                                  .map((tag) => Chip(
                                        label: AppText(
                                          text: "#$tag",
                                          color: AppColors.appColor,
                                        ),
                                        backgroundColor: AppColors.light_gray,
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                widget.haveComments
                    ? Column(
                        children: [
                          widget.currentUser == false
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    border: Border(
                                      top: BorderSide(
                                        color: AppColors.light_gray
                                            .withOpacity(0.2),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: SafeArea(
                                    top: false,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: homeController
                                                .commentController,
                                            style: TextStyle(
                                                color: AppColors.appColor),
                                            decoration: InputDecoration(
                                              hintText: "Write a comment...",
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                                fontSize: 16,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
                                              ),
                                              filled: true,
                                              fillColor: AppColors.greyShade,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                  color: AppColors
                                                      .textFiledBorderColor,
                                                  width: 1,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                  color: AppColors
                                                      .textFiledBorderColor,
                                                  width: 1,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                  color: AppColors.blue,
                                                  width: 1.5,
                                                ),
                                              ),
                                              suffixIcon:
                                                  ValueListenableBuilder<
                                                      TextEditingValue>(
                                                valueListenable: homeController
                                                    .commentController,
                                                builder: (context, value, _) {
                                                  return AnimatedOpacity(
                                                    opacity:
                                                        value.text.isNotEmpty
                                                            ? 1
                                                            : 0,
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        homeController
                                                            .commentController
                                                            .clear();
                                                      },
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: AppColors
                                                            .Slate_gray,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ValueListenableBuilder<
                                            TextEditingValue>(
                                          valueListenable:
                                              homeController.commentController,
                                          builder: (context, value, _) {
                                            return AnimatedScale(
                                              scale: value.text.isNotEmpty
                                                  ? 1
                                                  : 0.85,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child: MaterialButton(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                shape: CircleBorder(),
                                                color: value.text.isNotEmpty
                                                    ? AppColors.blue
                                                    : AppColors.light_gray,
                                                onPressed: value.text.isNotEmpty
                                                    ? () async {
                                                        if (widget
                                                                .currentUser ==
                                                            false) {
                                                          await homeController
                                                              .addComments(
                                                                  widget
                                                                      .post.id,
                                                                  widget.post);
                                                        }
                                                      }
                                                    : null,
                                                child: Icon(
                                                  Icons.arrow_circle_up,
                                                  color: AppColors.white,
                                                  size: 28,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Obx(() => widget.post.comments.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.post.comments.length,
                                  itemBuilder: (context, index) {
                                    var comment = widget.post.comments[index];
                                    User user = comment.user;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 26,
                                                backgroundImage: (user
                                                                .profileImage !=
                                                            null &&
                                                        user.profileImage!
                                                            .isNotEmpty)
                                                    ? NetworkImage(
                                                        user.profileImage!)
                                                    : AssetImage(
                                                            AppImages.person)
                                                        as ImageProvider,
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    user.name,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: AppColors.appColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width * 0.4,
                                                        child: Text(
                                                          maxLines: 3,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          comment.text,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .appColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          homeController
                                                              .toggleReplyBox(
                                                                  comment.id);
                                                        },
                                                        child: AppText(
                                                          text: "Reply",
                                                          color:
                                                              AppColors.green,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Obx(
                                                        () => GestureDetector(
                                                          onTap: () async {
                                                            await homeController
                                                                .addLikeToComment(
                                                                    widget.post
                                                                        .id,
                                                                    comment.id,
                                                                    comment);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                comment.isCommentLikedByUser
                                                                        .value
                                                                    ? Icons
                                                                        .thumb_up_alt
                                                                    : Icons
                                                                        .thumb_up_alt_outlined,
                                                                size: 20,
                                                                color: comment
                                                                        .isCommentLikedByUser
                                                                        .value
                                                                    ? AppColors
                                                                        .green
                                                                    : AppColors
                                                                        .appColor,
                                                              ),
                                                              Obx(() => Text(
                                                                  "${comment.likes?.length ?? 0}")),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Obx(() => homeController
                                                      .selectedCommentId
                                                      .value ==
                                                  comment.id
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 3,
                                                      left: Get.width * 0.2),
                                                  child: TextField(
                                                    autofocus: true,
                                                    cursorColor:
                                                        AppColors.green,
                                                    controller: homeController
                                                        .commentReplyController,
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.appColor),
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Write a reply...",
                                                      hintStyle: TextStyle(
                                                          color: AppColors
                                                              .Slate_gray),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              AppColors.green,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              AppColors.green,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons.send,
                                                            color: AppColors
                                                                .green),
                                                        onPressed: () {
                                                          homeController
                                                              .addReplyToComment(
                                                            widget.post.id,
                                                            comment.id,
                                                            widget.post,
                                                            homeController
                                                                .commentReplyController
                                                                .text,
                                                          );
                                                          homeController
                                                              .commentReplyController
                                                              .clear();
                                                          homeController
                                                              .selectedCommentId
                                                              .value = '';
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink()),
// Inside the comment's Column, replace the replies ListView.builder with this:
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8, left: Get.width * 0.22),
                                            child: Obx(
                                              () => ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    comment.replies?.length ??
                                                        0,
                                                itemBuilder:
                                                    (context, replyIndex) {
                                                  var commentData = comment
                                                      .replies![replyIndex];
                                                  var commentReply =
                                                      commentData.text;
                                                  var user = commentData.user;

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Dashed line and indentation
                                                        SizedBox(
                                                          width:
                                                              32, // Fixed indentation for the dashed line
                                                          child: CustomPaint(
                                                            painter: DashedLinePainter(
                                                                color: AppColors
                                                                    .Slate_gray),
                                                            size: Size(2,
                                                                40), // Adjust height based on reply content
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 16,
                                                                backgroundImage: user
                                                                        .profileImage!
                                                                        .isNotEmpty
                                                                    ? NetworkImage(user
                                                                        .profileImage!)
                                                                    : AssetImage(
                                                                            AppImages.person)
                                                                        as ImageProvider,
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      user.name,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            13,
                                                                        color: AppColors
                                                                            .appColor,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            1),
                                                                    LayoutBuilder(
                                                                      builder:
                                                                          (context,
                                                                              constraints) {
                                                                        return Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Flexible(
                                                                              flex: 3,
                                                                              child: Text(
                                                                                commentReply,
                                                                                maxLines: 3,
                                                                                textAlign: TextAlign.start,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: GoogleFonts.poppins(
                                                                                  fontSize: 12,
                                                                                  color: AppColors.appColor,
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 8), // Add spacing between text and like
                                                                            Obx(
                                                                              () => GestureDetector(
                                                                                onTap: () {
                                                                                  homeController.addLikeToReply(
                                                                                    widget.post.id,
                                                                                    comment.id,
                                                                                    commentData.id,
                                                                                    commentData,
                                                                                  );
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      commentData.isReplyLikedByUser!.value ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                                                                                      size: 20,
                                                                                      color: commentData.isReplyLikedByUser!.value ? AppColors.green : AppColors.appColor,
                                                                                    ),
                                                                                    const SizedBox(width: 4),
                                                                                    Obx(() => Text(
                                                                                          "${commentData.replyLikesCount!.length}",
                                                                                          style: GoogleFonts.poppins(fontSize: 12),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : SizedBox.shrink()),
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }
}
