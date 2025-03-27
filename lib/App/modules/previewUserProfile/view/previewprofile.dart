import 'dart:developer';

import 'package:civitante/App/modules/followlist/view/followlist_screen.dart';
import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/modules/shimmer/profile_gridview_shimmer.dart';
import 'package:civitante/App/shared/app_button.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/Post.dart';
import '../../../routes/routes.dart';
import '../../home/widgets/engament_row.dart';
import '../../kpi/view/kpis_screen.dart';
import '../controller/preview_profile_controller.dart';
import '../widget/status_row.dart';

class PreviewProfileScreen extends StatelessWidget {
  final String id;

  const PreviewProfileScreen({super.key, this.id = ''});

  @override
  Widget build(BuildContext context) {
    final PreviewProfileController controller =
        Get.put(PreviewProfileController(id));

    return Scaffold(
      // Hide drawer if currentUser is false
      appBar: HomeAppbar(
        title: "Profile",
        rightIcon: AppImages.notification,
      ),
      backgroundColor: Colors.white,
      body: Obx(() => RefreshIndicator(
            onRefresh: () async => await controller.fetchAndAssignPosts(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: _buildContent(controller),
            ),
          )),
    );
  }

  Widget _buildContent(PreviewProfileController controller) {
    // if (controller.isLoading.value) {
    //   return SizedBox(
    //     height: Get.height * 0.8,
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }

    if (controller.isError.value) {
      return SizedBox(
        height: Get.height * 0.8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(text: 'Failed to load profile'),
              SizedBox(height: 16),
              AppButton(
                text: 'Retry',
                onPressed: controller.fetchAndAssignPosts,
                width: 100,
              )
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warning and other existing widgets
        //   Warning(),
        Obx(() => Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(controller.imageUrl.value),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: AppText(
                                  text: controller.name.value,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.appColor),
                            ),

                            // Image.asset(
                            //   AppImages.share,
                            //   height: 25,
                            //   width: 25,
                            // )
                          ],
                        ),
                        SizedBox(height: 4),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.followUnfollowUser("follow");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.textFieldHintColor,
                                      width: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppColors.Slate_gray,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    AppText(
                                      text: "Follow",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.Slate_gray,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10), // Spacing between buttons
                            GestureDetector(
                              onTap: () {
                                controller.followUnfollowUser("unfollow");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.textFieldHintColor,
                                      width: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.remove,
                                      color: AppColors.Slate_gray,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    AppText(
                                      text: "Unfollow",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.Slate_gray,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Obx(() => ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.transparent,
                        //         shadowColor: Colors.transparent,
                        //         side: BorderSide(
                        //             color: AppColors.textFieldHintColor,
                        //             width: 0.4),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //       ),
                        //       onPressed: () {
                        //         controller.followUnfollowUser("follow");
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: AppText(
                        //             text: controller.isFollow == false
                        //                 ? '+ Follow'
                        //                 : 'Unfollow',
                        //             fontWeight: FontWeight.w600,
                        //             fontSize: 14,
                        //             color: AppColors.Slate_gray),
                        //       ),
                        //     )),
                        if (controller.isFollow == true)
                          AppButton(
                            textColor: AppColors.white,
                            height: 20,
                            hasBorder: true,
                            radius: 32,
                            width: Get.width * 0.50,
                            text: "Gift CPTs to followers",
                            onPressed: () {},
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      height: 30,
                      textColor: AppColors.white,
                      text: "KPIs & Stats",
                      onPressed: () {
                        log("Uid is $id");
                        Get.to(
                            KpisScreen(
                              userId: id,
                            ),
                            transition: Transition.zoom,
                            duration: Duration(microseconds: 300));
                      },
                    ),
                  )
                ],
              ),
            )),

        // Obx(() => Padding(
        //   padding: const EdgeInsets.only(left: 16, top: 5),
        //   child: Row(
        //     children: [
        //       Image.asset(AppImages.location, height: 20),
        //       AppText(text: controller.location.value)
        //     ],
        //   ),
        // )),

        Obx(() => Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatItem(title: 'Posts', value: controller.posts.length),
                  VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                    width: 20,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(FollowListScreen(
                          isFollowing: false, userID: controller.id));
                    },
                    child: StatItem(
                        title: 'Followers', value: controller.followers.value),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                    width: 20,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(FollowListScreen(
                        isFollowing: true,
                        userID: controller.id,
                      ));
                    },
                    child: StatItem(
                        title: 'Following', value: controller.following.value),
                  ),
                ],
              ),
            )),

        // SizedBox(height: 6),
        // Divider(),
        // SizedBox(height: 16),
        StatsRow(),
        SizedBox(
          height: 16,
        ),

        Obx(() {
          if (controller.isLoading.value) {
            return ProfileGridViewShimmer();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.posts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final post = controller.posts[index];
                  return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.postDetail,
                            arguments: {"data": post, 'currentUser': true});
                      },
                      child: GridItem(post: controller.posts[index]));
                },
              ),
            );
          }
        }),
      ],
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final int value;

  const StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
            text: value.toString(),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.appColor),
        SizedBox(height: 4),
        AppText(
            text: title,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.Slate_gray),
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  Post post;

  GridItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(post.mediaUrls[0]),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Views Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.view,
                        height: 25,
                        color:
                            post.views > 0 ? AppColors.green : AppColors.white,
                      ),
                      label: post.views.toString(),
                      textColor: AppColors.white,
                    ),
                    SizedBox(width: 10),

                    // Likes Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.like,
                        height: 25,
                        color: post.likesCount > 0
                            ? AppColors.appColor
                            : AppColors.white,
                      ),
                      label: post.likesCount.toString(),
                      textColor: AppColors.white,
                    ),
                    SizedBox(width: 10),

                    // Comments Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.comment,
                        height: 25,
                        color: AppColors.white,
                      ),
                      label: post.commentsCount.toString(),
                      textColor: AppColors.white,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
