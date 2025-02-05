import 'package:civitante/App/modules/drawer/view/drawer.dart';
import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/shared/app_button.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/Post.dart';
import '../../../routes/routes.dart';
import '../../home/widgets/engament_row.dart';
import '../controller/profile_controller.dart';
import '../widget/status_row.dart';

class ProfileScreen extends StatelessWidget {
  final bool currentUser;

  const ProfileScreen({super.key, this.currentUser = false});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      drawer: CustomDrawer(),
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

  Widget _buildContent(ProfileController controller) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(AppImages.person),
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

                     currentUser==true?   ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            side: BorderSide(
                                color: AppColors.textFieldHintColor,
                                width: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppText(
                                text: '+ Follow',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.Slate_gray),
                          ),
                        ):SizedBox(),
                      ],
                    ),
                  ),
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
                  StatItem(
                      title: 'Followers', value: controller.followers.value),
                  VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                    width: 20,
                    indent: 10,
                    endIndent: 10,
                  ),
                  StatItem(
                      title: 'Following', value: controller.following.value),
                ],
              ),
            )),

        SizedBox(height: 16),
        StatsRow(),

        Obx(() => Padding(
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
            )),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Spread items evenly
                children: [
                  // Views Row
                  buildStatItem(
                    icon: Image.asset(
                      AppImages.view, // Replace with AppImages.view
                      height: 20,
                      color: AppColors.white, // Add custom color to the icon
                    ),
                    label: post.views.toString(),
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
                    label: post.likesCount.toString(),
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
                    label: post.commentsCount.toString(),
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
