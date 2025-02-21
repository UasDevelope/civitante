import 'dart:developer';
import 'package:civitante/App/modules/home/widgets/filter_menues.dart';

import 'package:civitante/App/modules/loading/empty_data.dart';

import 'package:civitante/App/modules/previewUserProfile/view/previewprofile.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Models/Post.dart';
import '../../PostsDetails/view/posts_details_screen.dart';
import '../../shimmer/randomized_shimmer_post.dart';
import '../controller/home_controller.dart';
import '../widgets/engament_row.dart';
import '../widgets/home_search.dart';
import '../widgets/slider_label.dart';

class RandomSizedPostsScreen extends StatelessWidget {
  final String communityId;
  final bool explore;
  final bool? followed;
  final bool? randomized;
  const RandomSizedPostsScreen(
      {super.key,
      this.communityId = "",
      this.explore = false,
      this.followed = false,
      this.randomized = false});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            if (explore == true)
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: HomeSerchField(
                  hintText: "Search here...", // Custom hint text
                  onChanged: (value) {
                    homeController.changeSearchValue(value);
                  },
                ),
              ),
            if (explore == true) SizedBox(height: 10),
            if (explore == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
            Expanded(
              child: RefreshIndicator(
                color: AppColors.appColor,
                onRefresh: () async {
                  // Call your refresh method from the controller
                  await homeController.fetchAndAssignPosts(
                      communityId: communityId,
                      randomized: randomized,
                      followed: followed);
                },
                child: Obx(() {
                  if (homeController.isPostLoading.value) {
                    return RandomizedShimmerPost();
                  }
                  //For the empty post
                  else if (homeController.filteredPosts.isEmpty) {
                    return LottieAnimationWidget();
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: homeController.filteredPosts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = homeController.filteredPosts[index];
                        return GestureDetector(
                          onTap: () {
                            var response =
                                homeController.viewPostById(post.id, index);
                            print('here is value ${response}');

                            /// post.views.value = response['likesCount'];

                            Get.toNamed(AppRoutes.postDetail, arguments: {
                              "data": post,
                              "currentUser": false
                            });
                            // Get.to(() => PostsDetailsScreen());
                          },
                          child: CustomCard2(
                            haveDescAndTags: false,
                            post: post,
                            index: index,
                          ),
                          // child:  MediumNativeAd(), // Add the native ad here,
                        );
                      },
                    );
                  }
                }),
              ),
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
      this.index = 0, required this.haveDescAndTags, this.topTitle = true});
  final bool haveComments;
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

    return Obx(() => Card(
          color: AppColors.white,
          // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
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
                        widget.post.createdBy.profileImage.toString().isNotEmpty
                            ? NetworkImage(
                                widget.post.createdBy.profileImage.toString() ??
                                    AppImages.person)
                            : AssetImage(AppImages.person.toString() ??
                                AppImages.person), // Replace with your image
                  ),
                ),
                title: AppText(
                    text: widget.post.createdBy.name.toString(),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                trailing: homeController
                            .filteredPosts[widget.index].isReported.value !=
                        true
                    ? PopupMenuButton(
                        icon: Image.asset(
                          AppImages.menue,
                          height: 30,
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                            side: BorderSide(
                              color:
                                  AppColors.textFieldHintColor, // Border color
                              width: 0.4, // Border width
                            )),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: AppText(
                                text: AppStrings.Report,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            onTap: () async {
                              homeController.filteredPosts[widget.index]
                                      .isReported.value =
                                  await homeController.reportPost(
                                      widget.post.id, widget.index);
                            },
                          ),
                          PopupMenuItem(
                            child: AppText(
                                text: "Block",
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            onTap: () async {
                              HttpService.post("/blockPost/${homeController.filteredPosts[widget.index].id}", {});
                              Get.back();
                              log("Block Button Click");
                            },
                          ),
                        ],
                      )
                    : AppText(
                        text: AppStrings.Reported,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.topTitle?AppText(
                      text: widget.post.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ):SizedBox.shrink(),
                    SizedBox(height: 4),
                  ],
                ),
              ),
              SizedBox(
                height: widget.topTitle? 200:450,
                child: Stack(
                  children: [
                    // PageView.builder(
                    //   itemCount: widget.post.mediaUrls.length,
                    //   itemBuilder: (context, index) {
                    //     return Image.network(
                    //       widget.post.mediaUrls[index],
                    //       fit: BoxFit.cover,
                    //       loadingBuilder: (context, child, loadingProgress) {
                    //         if (loadingProgress == null) return child;
                    //         return Center(
                    //           child: CircularProgressIndicator(
                    //             value: loadingProgress.expectedTotalBytes !=
                    //                 null
                    //                 ? loadingProgress.cumulativeBytesLoaded /
                    //                 loadingProgress.expectedTotalBytes!
                    //                 : null,
                    //           ),
                    //         );
                    //       },
                    //       errorBuilder: (context, error, stackTrace) =>
                    //       const Icon(Icons.error),
                    //     );
                    //   },
                    // ),
                    Image.network(
                      widget.post.mediaUrls.isNotEmpty ? widget.post.mediaUrls.first : '',
                      fit: BoxFit.fitWidth,
                      width: Get.width,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              log("Printed image");
                            },
                            child: buildStatItem(
                              icon: Image.asset(
                                AppImages.view,
                                height: 25,
                                color: widget.post.isViewed == true
                                    ? AppColors.green
                                    : AppColors.white,
                              ),
                              label: widget.post.views.toString(),
                              textColor: AppColors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(() {
                            return GestureDetector(
                              onTap: () async {
                                // Use `await` to make sure the like count updates correctly
                                if (widget.currentUser == false) {
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
                  height: Get.height * 0.08,
                  child: SliderWithLabels(
                    post: widget.post,
                  )),
             widget.haveDescAndTags? Padding(
                padding: EdgeInsets.only(top: 0, bottom: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !widget.topTitle?AppText(
                      text: widget.post.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ):SizedBox.shrink(),
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
              ):SizedBox.shrink(),
              widget.haveComments
                  ? Column(
                      children: [
                        Obx(() => ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.post.comments.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 26,
                                            backgroundImage: widget
                                                    .post
                                                    .comments[index]
                                                    .user
                                                    .profileImage
                                                    .toString()
                                                    .isNotEmpty
                                                ? NetworkImage(widget.post
                                                        .createdBy.profileImage
                                                        .toString() ??
                                                    AppImages.person)
                                                : AssetImage(AppImages.person
                                                        .toString() ??
                                                    AppImages.person),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    widget.post.comments[index]
                                                        .user.name,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color:
                                                            AppColors.appColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  // Text(
                                                  //   "@kiero_d ·2d",
                                                  //   style: GoogleFonts.poppins(
                                                  //       fontSize: 16,
                                                  //       color: AppColors.Slate_gray,
                                                  //       fontWeight: FontWeight.w400),
                                                  // ),
                                                ],
                                              ),
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       "Replying to",
                                              //       style: GoogleFonts.poppins(
                                              //           fontSize: 16,
                                              //           color: AppColors.Slate_gray,
                                              //           fontWeight: FontWeight.w400),
                                              //     ),
                                              //     SizedBox(
                                              //       width: 4,
                                              //     ),
                                              //     Text(
                                              //       "@karennne",
                                              //       style: GoogleFonts.poppins(
                                              //           fontSize: 16,
                                              //           color: AppColors.blue,
                                              //           fontWeight: FontWeight.w400),
                                              //     ),
                                              //   ],
                                              // ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.6,
                                                child: Text(
                                                  maxLines: 3,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "${widget.post.comments[index].text}",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: AppColors.appColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.all(8.0),
                                              //   child: Row(
                                              //     mainAxisAlignment: MainAxisAlignment
                                              //         .end, // Spread items evenly
                                              //     children: [
                                              //       // Views Row
                                              //       buildStatItem(
                                              //         icon: Image.asset(
                                              //           AppImages
                                              //               .like, // Replace with AppImages.view
                                              //           height: 20,
                                              //           color: AppColors
                                              //               .Slate_gray, // Add custom color to the icon
                                              //         ),
                                              //         label: '25',
                                              //         textColor: AppColors.Slate_gray,
                                              //       ),
                                              //       SizedBox(
                                              //         width: 10,
                                              //       ),
                                              //       // Likes Row
                                              //       buildStatItem(
                                              //         icon: Image.asset(
                                              //           AppImages
                                              //               .chat, // Replace with AppImages.view
                                              //           height: 28,
                                              //           color: AppColors
                                              //               .Slate_gray, // Add custom color to the icon
                                              //         ),
                                              //         label: '25',
                                              //         textColor: AppColors.Slate_gray,
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      )
                                    ],
                                  ),
                                );
                              },
                            )),
                        widget.currentUser == false
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
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
                                        child: CupertinoTextField(
                                          controller:
                                              homeController.commentController,
                                          placeholder: "Write a comment...",
                                          placeholderStyle: TextStyle(
                                            color: CupertinoColors
                                                .placeholderText
                                                .resolveFrom(context),
                                            fontSize: 16,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CupertinoColors
                                                .secondarySystemBackground
                                                .resolveFrom(context),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border: Border.all(
                                              color: CupertinoColors.systemGrey5
                                                  .resolveFrom(context),
                                              width: 1,
                                            ),
                                          ),
                                          suffix: ValueListenableBuilder<
                                              TextEditingValue>(
                                            valueListenable: homeController
                                                .commentController,
                                            builder: (context, value, _) {
                                              return AnimatedOpacity(
                                                opacity: value.text.isNotEmpty
                                                    ? 1
                                                    : 0,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    homeController
                                                        .commentController
                                                        .clear();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: Icon(
                                                      CupertinoIcons
                                                          .xmark_circle_fill,
                                                      color: CupertinoColors
                                                          .systemGrey
                                                          .resolveFrom(context),
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ValueListenableBuilder<TextEditingValue>(
                                        valueListenable:
                                            homeController.commentController,
                                        builder: (context, value, _) {
                                          return AnimatedScale(
                                            scale: value.text.isNotEmpty
                                                ? 1
                                                : 0.85,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: CupertinoButton(
                                              padding: const EdgeInsets.all(12),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              minSize: 0,
                                              color: value.text.isNotEmpty
                                                  ? CupertinoColors.systemBlue
                                                  : CupertinoColors.systemGrey4,
                                              onPressed: value.text.isNotEmpty
                                                  ? () async {
                                                      final newComment =
                                                          Comment(
                                                        id: UniqueKey()
                                                            .toString(),
                                                        user: User(
                                                            id: widget.post
                                                                .createdBy.id,
                                                            name: widget
                                                                .post
                                                                .createdBy
                                                                .name),
                                                        text: homeController
                                                            .commentController
                                                            .text,
                                                        createdAt:
                                                            DateTime.now(),
                                                      );

                                                      // Add comment to observable list
                                                      widget.post.comments
                                                          .add(newComment);

                                                      // Optionally refresh UI immediately
                                                      (widget.post.comments
                                                              as RxList)
                                                          .refresh();

                                                      // Post to backend
                                                      if (widget.currentUser ==
                                                          false) {
                                                        await homeController
                                                            .addComments(
                                                                widget.post.id);
                                                      }
                                                    }
                                                  : null,
                                              child: Icon(
                                                CupertinoIcons
                                                    .arrow_up_circle_fill,
                                                color: CupertinoColors.white,
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
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ));
  }
}
