import 'dart:developer';

import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/modules/CommunityPost/view/community_post_screen.dart';
import 'package:civitante/App/modules/chat/view/community_chat.dart';
import 'package:civitante/App/modules/mycommunites/view/invite_member.dart';
import 'package:civitante/App/modules/mycommunites/view/members_in_community.dart';
import 'package:flutter/material.dart';
import '../../../utilse/widgets.dart';
import '../../home/view/ramdomsized_posts.dart';
import '../../meeting/view/new_meeting_view.dart';
import '../controller/communityDetailsController.dart';
import '../widgets/communityButton.dart';

class MyCommunityDetail extends StatefulWidget {
  final MyCommunityModel? community;
  final bool isAllCommunity;

  MyCommunityDetail({super.key, this.community, this.isAllCommunity = false});

  @override
  State<MyCommunityDetail> createState() => _MyCommunityDetailState();
}

class _MyCommunityDetailState extends State<MyCommunityDetail> {

  final CommunityDetailController controller =
      Get.put(CommunityDetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.community != null) {
        final communityPostController = LocateController.homeController;
        communityPostController.fetchAndAssignPosts(
            communityId: widget.community!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // communityPostController.fetchAndAssignPosts(communityId: widget.community!.id);

    return Scaffold(
        backgroundColor: Colors.white, // Change the background color
        appBar: HomeAppbar(
          title: AppStrings.Community,
          onRightIconPressed: () {},
        ),
        // drawer: CustomDrawer(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Profile Avatar and Actions
                    // Text(
                    //   controller.isPosting.value.toString(),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Avatar with Overlay
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius:40,
                                    backgroundImage:
                                    NetworkImage(widget.community!.image),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        AppText(
                                            text: widget.community!.name,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: AppColors.appColor),
                                        const SizedBox(height: 4),
                                        InkWell(
                                          onTap: () {

                                            Get.to(MembersInCommunity(
                                                communityId: widget.community!.id));
                                          },
                                          child: AppText(
                                              text:
    '${widget.community!.totalMembers} ${widget.community!.totalMembers<=1?"member":"members"}',
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.moreblue,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                          width: 88,
                        ),
                        // Action Buttons
                        if (!widget.isAllCommunity)
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildActionCommunityButton(AppImages.addCircle, () {
                                Get.to(InviteMember(
                                  communityId: widget.community!.id,
                                ));
                              }),

                              buildActionCommunityButton(AppImages.eidt, () {
                                Get.toNamed(AppRoutes.editMycommunity,
                                    arguments: {"data": widget.community!});
                              }),
                              // buildActionCommunityButton(AppImages.video, () {
                              //   Get.to(NewMeetingView());
                              // }),
                              buildActionCommunityButton(AppImages.chat, () {
                                Get.to(CommunityChat(
                                  communityId: widget.community!.id,
                                ));
                              }),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     color: AppColors
                              //         .light_gray, // Adjust color as needed
                              //   ),
                              //   child: IconButton(
                              //     onPressed: () {
                              //       Get.to(CommunityChat(
                              //         communityId: widget.community!.id,
                              //       ));
                              //       // Add your chat functionality here
                              //     },
                              //     icon: Icon(
                              //       Icons.chat_outlined,
                              //       color: Colors.white,
                              //       size: 20,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        if (widget.isAllCommunity)
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildActionCommunityButton(AppImages.addCircle, () {
                                Get.toNamed(AppRoutes.post, arguments: {
                                  "communityId": widget.community!.id
                                });
                              }),
                              buildActionCommunityButton(AppImages.chat, () {
                                Get.to(CommunityChat(
                                  communityId: widget.community!.id,
                                ));
                                log("Print");
                              }),
                            ],
                          ),
                      ],
                    ),
                    // Community Name and Members

                    const SizedBox(height: 16),
                    // Description
                    AppText(
                        text: widget.community!.description,
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
                                text: '${widget.community!.cost} points',
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
                  ],
                ),
              ),
            ),
              // ListView for Posts
              Expanded(
                  child: RandomSizedPostsScreen(
                    isCommunityDetails: true,
                communityId: widget.community!.id,
              ))

              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 5, // Replace with your dynamic item count
              //     itemBuilder: (BuildContext context, int index) {
              //       return GestureDetector(
              //           onTap: () {
              //             Get.to(CommunityPostScreen());
              //           },
              //           child: CustomCard());
              //     },
              //   ),
              // ),
            ],
          ),
        ));
  }
}
