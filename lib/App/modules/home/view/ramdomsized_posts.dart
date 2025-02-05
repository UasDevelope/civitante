import 'dart:developer';
import 'package:civitante/App/modules/home/widgets/filter_menues.dart';

import 'package:civitante/App/modules/loading/empty_data.dart';

import 'package:civitante/App/modules/previewUserProfile/view/previewprofile.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Models/Post.dart';
import '../../shimmer/randomized_shimmer_post.dart';
import '../controller/home_controller.dart';
import '../widgets/engament_row.dart';
import '../widgets/slider_label.dart';

class RandomSizedPostsScreen extends StatelessWidget {
  final String communityId;
  const RandomSizedPostsScreen({super.key, this.communityId = ""});

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
            Align(
              alignment: Alignment.topRight,
              child: HomeFilterMenues(
                onSelected: (value) {
                  if (value == 'Comments') {
                    homeController.sortByComments();
                  } else {
                    homeController.sortByLikes();
                  }
                  print("selected=>$value");
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.appColor,
                onRefresh: () async {
                  // Call your refresh method from the controller
                  await homeController.fetchAndAssignPosts(
                      communityId: communityId);
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
                            post: post,
                            index: index,
                          ),
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

class CustomCard1 extends StatelessWidget {
  CustomCard1({
    super.key,
    required this.post,
    this.haveComments = false,
  });

  final Post post;
  final bool haveComments;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            // leading: CircleAvatar(
            //   backgroundImage: post.createdBy.profileImage.isNotEmpty
            //       ? NetworkImage(post.createdBy.profileImage)
            //       : AssetImage(AppImages.person) as ImageProvider,
            // ),
            title: AppText(
              text: post.createdBy.name,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            trailing: PopupMenuButton(
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
                    text: "Report",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: post.mediaUrls.length,
              itemBuilder: (context, index) {
                return Image.network(
                  post.mediaUrls[index],
                  fit: BoxFit.cover,
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
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: post.title,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8),
                AppText(
                  text: post.description,
                  fontSize: 16,
                  color: AppColors.Slate_gray,
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: post.tags
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
          ),
          // EngagementRow(
          //   views: post.views,
          //   likes: post.likes.length,
          //   comments: post.comments.length,
          // ),
          // if (haveComments && post.comments.isNotEmpty)
          //   Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: post.comments.length,
          //       itemBuilder: (context, index) {
          //         final comment = post.comments[index];
          //         return Padding(
          //           padding: EdgeInsets.only(bottom: 12),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               // Row(
          //               //   crossAxisAlignment: CrossAxisAlignment.start,
          //               //   children: [
          //               //     CircleAvatar(
          //               //       radius: 20,
          //               //       backgroundImage:
          //               //           comment.user.profileImage.isNotEmpty
          //               //               ? NetworkImage(comment.user.profileImage)
          //               //               : AssetImage(AppImages.person)
          //               //                   as ImageProvider,
          //               //     ),
          //               //     SizedBox(width: 8),
          //               //     Expanded(
          //               //       child: Column(
          //               //         crossAxisAlignment: CrossAxisAlignment.start,
          //               //         children: [
          //               //           // Row(
          //               //           //   children: [
          //               //           //     Text(
          //               //           //       comment.user.username,
          //               //           //       // comment.user.username,
          //               //           //       style: GoogleFonts.poppins(
          //               //           //         fontSize: 14,
          //               //           //         fontWeight: FontWeight.w600,
          //               //           //         color: AppColors.appColor,
          //               //           //       ),
          //               //           //     ),
          //               //           //     SizedBox(width: 4),
          //               //           //     Text(
          //               //           //       "@${comment.user.username} · ${comment.timeAgo}",
          //               //           //       style: GoogleFonts.poppins(
          //               //           //         fontSize: 12,
          //               //           //         color: AppColors.Slate_gray,
          //               //           //       ),
          //               //           //     ),
          //               //           //   ],
          //               //           // ),
          //               //           Text(
          //               //             comment.text,
          //               //             style: GoogleFonts.poppins(
          //               //               fontSize: 14,
          //               //               color: AppColors.appColor,
          //               //             ),
          //               //             maxLines: 3,
          //               //             overflow: TextOverflow.ellipsis,
          //               //           ),
          //               //           SizedBox(height: 8),
          //               //           Row(
          //               //             mainAxisAlignment: MainAxisAlignment.end,
          //               //             children: [
          //               //               buildStatItem(
          //               //                 icon: Image.asset(
          //               //                   AppImages.like,
          //               //                   height: 18,
          //               //                   color: AppColors.Slate_gray,
          //               //                 ),
          //               //                 label: comment.likes.toString(),
          //               //                 textColor: AppColors.Slate_gray,
          //               //               ),
          //               //               SizedBox(width: 16),
          //               //               buildStatItem(
          //               //                 icon: Image.asset(
          //               //                   AppImages.chat,
          //               //                   height: 18,
          //               //                   color: AppColors.Slate_gray,
          //               //                 ),
          //               //                 label:
          //               //                     comment.replies.length.toString(),
          //               //                 textColor: AppColors.Slate_gray,
          //               //               ),
          //               //             ],
          //               //           ),
          //               //         ],
          //               //       ),
          //               //     ),
          //               //   ],
          //               // ),
          //               Divider(height: 24),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget buildStatItem({
    required Widget icon,
    required String label,
    Color textColor = const Color(0xFFFFFFFF), // Use const color directly
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 4),
        AppText(
          text: label,
          fontSize: 12,
          color: textColor,
        ),
      ],
    );
  }
}

class CustomCard2 extends StatefulWidget {
  CustomCard2(
      {super.key,
      this.haveComments = false,
      required this.post,
      this.currentUser = false,
      this.index = 0});
  final bool haveComments;
  final Post post;
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
                        ],
                      )
                    : AppText(
                        text: AppStrings.Reported,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: widget.post.mediaUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.post.mediaUrls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        );
                      },
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
                              textColor: AppColors.white,
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
                                textColor: AppColors.white,
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
                            textColor: AppColors.white,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: Get.height * 0.07,
                  child: SliderWithLabels(
                    post: widget.post,
                  )),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: widget.post.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8),
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
              ),
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

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, this.haveComments = false, this.postImage = ""});
  final bool haveComments;
  final String postImage;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            leading: CircleAvatar(
              backgroundImage:
                  AssetImage(AppImages.person), // Replace with your image
            ),
            title: AppText(
                text: "Sara Mathew", fontWeight: FontWeight.w500, fontSize: 16),
            trailing: PopupMenuButton(
              icon: Image.asset(
                AppImages.menue,
                height: 30,
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  side: BorderSide(
                    color: AppColors.textFieldHintColor, // Border color
                    width: 0.4, // Border width
                  )),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: AppText(
                      text: AppStrings.Report,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(16),
              gradient: postImage.isEmpty
                  ? LinearGradient(
                      colors: [Colors.blue, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              image: postImage.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(postImage),
                      fit: BoxFit.cover, // Adjust this as needed
                    )
                  : null,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Spread items evenly
                  children: [
                    // Views Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.view,
                        height: 20,
                        color: AppColors.white,
                      ),
                      label: '25',
                      textColor: AppColors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Likes Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.like, // Replace with AppImages.view
                        height: 15,
                        color: AppColors.white, // Add custom color to the icon
                      ),
                      label: '25',
                      textColor: AppColors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Comments Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.comment, // Replace with AppImages.view
                        height: 15,
                        color: AppColors.white, // Add custom color to the icon
                      ),
                      label: '25',
                      textColor: AppColors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          //  Container(height: Get.height * 0.1, child: SliderWithLabels()),
          haveComments
              ? SizedBox(
                  height: 8,
                )
              : SizedBox.shrink(),
          haveComments
              ? Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundImage:
                                        AssetImage(AppImages.person),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "kiero_d",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: AppColors.appColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "@kiero_d ·2d",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: AppColors.Slate_gray,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Replying to",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: AppColors.Slate_gray,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "@karennne",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: AppColors.blue,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.6,
                                        child: Text(
                                          maxLines: 3,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          "Interesting Nicola that not one reply or tag on this #UX talent shout out in the 24hrs since your tweet here......🤔",
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: AppColors.appColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end, // Spread items evenly
                                          children: [
                                            // Views Row
                                            buildStatItem(
                                              icon: Image.asset(
                                                AppImages
                                                    .like, // Replace with AppImages.view
                                                height: 20,
                                                color: AppColors
                                                    .Slate_gray, // Add custom color to the icon
                                              ),
                                              label: '25',
                                              textColor: AppColors.Slate_gray,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            // Likes Row
                                            buildStatItem(
                                              icon: Image.asset(
                                                AppImages
                                                    .chat, // Replace with AppImages.view
                                                height: 28,
                                                color: AppColors
                                                    .Slate_gray, // Add custom color to the icon
                                              ),
                                              label: '25',
                                              textColor: AppColors.Slate_gray,
                                            ),
                                          ],
                                        ),
                                      ),
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
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
