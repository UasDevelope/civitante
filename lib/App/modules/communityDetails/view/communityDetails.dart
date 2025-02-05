import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/modules/CommunityPost/view/community_post_screen.dart';
import 'package:civitante/App/modules/mycommunites/view/invite_member.dart';
import 'package:civitante/App/modules/mycommunites/view/members_in_community.dart';
import 'package:flutter/material.dart';
import '../../../utilse/widgets.dart';
import '../../home/view/ramdomsized_posts.dart';
import '../../meeting/view/new_meeting_view.dart';
import '../controller/communityDetailsController.dart';
import '../widgets/communityButton.dart';

class MyCommunityDetail extends StatelessWidget {
  final MyCommunityModel? community;
  final bool isAllCommunity;
  final CommunityDetailController controller =
      Get.put(CommunityDetailController());

  MyCommunityDetail({super.key, this.community, this.isAllCommunity = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // Change the background color
        appBar: HomeAppbar(
          title: AppStrings.Community,
          onRightIconPressed: () {},
        ),
        // drawer: CustomDrawer(),
        body: Obx(() => SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Avatar and Actions
                    Text(
                      controller.isPosting.value.toString(),
                    ),
                    Row(
                      mainAxisAlignment: isAllCommunity
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Avatar with Overlay
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(community!.image),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      AppText(
                                          text: community!.name,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: AppColors.appColor),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () {
                                          Get.to(MembersInCommunity(
                                              communityId: community!.id));
                                        },
                                        child: AppText(
                                            text:
                                                '${community!.totalMembers} members',
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.moreblue,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 50),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //
                            //     },
                            //     child: Image.asset(
                            //       AppImages.camera,
                            //       height: 30,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        // Action Buttons
                        if (!isAllCommunity)
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildActionCommunityButton(AppImages.addCircle,
                                  () {
                                Get.to(InviteMember(
                                  communityId: community!.id,
                                ));
                              }),
                              buildActionCommunityButton(AppImages.eidt, () {
                                Get.toNamed(AppRoutes.editMycommunity,
                                    arguments: {"data": community!});
                              }),
                              buildActionCommunityButton(AppImages.video, () {
                                Get.to(NewMeetingView());
                              }),
                            ],
                          ),
                        if (isAllCommunity)
                          buildActionCommunityButton(
                              AppImages.addCircle, () {}),
                      ],
                    ),
                    // Community Name and Members

                    const SizedBox(height: 16),
                    // Description
                    AppText(
                        text: '${community!.description}',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.Slate_gray),
                    const SizedBox(height: 15),
                    // Posting Tag Cost
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                                text: 'Posting Tag Cost',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.appColor),
                            AppText(
                                text: '${community!.cost} points',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.appColor),
                          ],
                        ),
                        SizedBox(height: 4),
                        AppText(
                            text: 'Set by admin',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.Slate_gray),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Recent Posts
                    AppText(
                        text: 'Recent Posts',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.appColor),
                    const SizedBox(height: 10),
                    // ListView for Posts
                    Expanded(
                      child: ListView.builder(
                        itemCount: 5, // Replace with your dynamic item count
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Get.to(CommunityPostScreen());
                              },
                              child: CustomCard());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  // Helper Method to Build Action Buttons
}
