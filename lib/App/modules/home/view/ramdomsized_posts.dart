import 'dart:developer';

import 'package:civitante/App/modules/PostsDetails/view/posts_details_screen.dart';
import 'package:civitante/App/modules/home/widgets/filter_menues.dart';
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
import '../widgets/EngagementRow.dart';
import '../widgets/engament_row.dart';
import '../widgets/slider_label.dart';

class RandomSizedPostsScreen extends StatelessWidget {
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
                  print("selected=>$value");
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.appColor,
                onRefresh: () async {
                  // Call your refresh method from the controller
                  await homeController.fetchAndAssignPosts();
                },
                child: Obx(() {
                  if (homeController.isPostLoading.value) {
                    return RandomizedShimmerPost();
                  }
                  //For the empty post
                  else if (homeController.filteredPosts.isEmpty) {
                    return Container();
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

                            Get.toNamed(AppRoutes.postDetail,
                                arguments: {"data": post});
                            // Get.to(() => PostsDetailsScreen());

                          },
                          child: CustomCard2(post: post),
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
            leading: CircleAvatar(
              backgroundImage: post.createdBy.profileImage.isNotEmpty
                  ? NetworkImage(post.createdBy.profileImage)
                  : AssetImage(AppImages.person) as ImageProvider,
            ),
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
          EngagementRow(
            views: post.views,
            likes: post.likes.length,
            comments: post.comments.length,
          ),
          if (haveComments && post.comments.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: post.comments.length,
                itemBuilder: (context, index) {
                  final comment = post.comments[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     CircleAvatar(
                        //       radius: 20,
                        //       backgroundImage:
                        //           comment.user.profileImage.isNotEmpty
                        //               ? NetworkImage(comment.user.profileImage)
                        //               : AssetImage(AppImages.person)
                        //                   as ImageProvider,
                        //     ),
                        //     SizedBox(width: 8),
                        //     Expanded(
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           // Row(
                        //           //   children: [
                        //           //     Text(
                        //           //       comment.user.username,
                        //           //       // comment.user.username,
                        //           //       style: GoogleFonts.poppins(
                        //           //         fontSize: 14,
                        //           //         fontWeight: FontWeight.w600,
                        //           //         color: AppColors.appColor,
                        //           //       ),
                        //           //     ),
                        //           //     SizedBox(width: 4),
                        //           //     Text(
                        //           //       "@${comment.user.username} · ${comment.timeAgo}",
                        //           //       style: GoogleFonts.poppins(
                        //           //         fontSize: 12,
                        //           //         color: AppColors.Slate_gray,
                        //           //       ),
                        //           //     ),
                        //           //   ],
                        //           // ),
                        //           Text(
                        //             comment.text,
                        //             style: GoogleFonts.poppins(
                        //               fontSize: 14,
                        //               color: AppColors.appColor,
                        //             ),
                        //             maxLines: 3,
                        //             overflow: TextOverflow.ellipsis,
                        //           ),
                        //           SizedBox(height: 8),
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.end,
                        //             children: [
                        //               buildStatItem(
                        //                 icon: Image.asset(
                        //                   AppImages.like,
                        //                   height: 18,
                        //                   color: AppColors.Slate_gray,
                        //                 ),
                        //                 label: comment.likes.toString(),
                        //                 textColor: AppColors.Slate_gray,
                        //               ),
                        //               SizedBox(width: 16),
                        //               buildStatItem(
                        //                 icon: Image.asset(
                        //                   AppImages.chat,
                        //                   height: 18,
                        //                   color: AppColors.Slate_gray,
                        //                 ),
                        //                 label:
                        //                     comment.replies.length.toString(),
                        //                 textColor: AppColors.Slate_gray,
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Divider(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
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

class CustomCard2 extends StatelessWidget {
  const CustomCard2({super.key, this.haveComments = false, required this.post});
  final bool haveComments;
  final Post post;

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
                text: "Mathews", fontWeight: FontWeight.w500, fontSize: 16),
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
            child: Stack(
              children: [
                PageView.builder(
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
                            height: 20,
                            color: AppColors.white,
                          ),
                          label: post.views.toString(),
                          textColor: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      buildStatItem(
                        icon: Image.asset(
                          AppImages.like,
                          height: 15,
                          color: AppColors.white,
                        ),
                        label: post.likes.length.toString(),
                        textColor: AppColors.white,
                      ),
                      const SizedBox(width: 10),
                      buildStatItem(
                        icon: Image.asset(
                          AppImages.comment,
                          height: 15,
                          color: AppColors.white,
                        ),
                        label: "10",
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
          Container(
              height: Get.height * 0.1,
              child: SliderWithLabels(
                postId: post.id,
              )),
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
          Container(height: Get.height * 0.1, child: SliderWithLabels()),
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
