import 'dart:developer';

import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/modules/CommunityPost/view/community_post_screen.dart';
import 'package:civitante/App/modules/chat/view/community_chat.dart';
import 'package:civitante/App/modules/mycommunites/view/invite_member.dart';
import 'package:civitante/App/modules/mycommunites/view/members_in_community.dart';
import 'package:flutter/material.dart';
import '../../../utilse/widgets.dart';
import '../../home/controller/home_controller.dart';
import '../../home/view/ramdomsized_posts.dart';
import '../../home/widgets/filter_menues.dart';
import '../../meeting/view/new_meeting_view.dart';
import '../controller/communityDetailsController.dart';
import '../widgets/communityButton.dart';

class MyCommunityDetail extends StatefulWidget {
  final MyCommunityModel? community;
  final bool isAllCommunity;

  const MyCommunityDetail({
    super.key,
    this.community,
    this.isAllCommunity = false,
  });

  @override
  State<MyCommunityDetail> createState() => _MyCommunityDetailState();
}

class _MyCommunityDetailState extends State<MyCommunityDetail> {
  final CommunityDetailController controller = Get.put(CommunityDetailController());
  final homeController = Get.find<HomeController>();


  @override
  void initState() {
    super.initState();
    _fetchCommunityPosts();
  }

  void _fetchCommunityPosts() {
    if (widget.community != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          LocateController.homeController.fetchAndAssignPosts(
            communityId: widget.community!.id,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.community == null) {
      return const Scaffold(body: Center(child: Text('No community data')));
    }

    final bool isJoined = widget.community!.isJoined;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppbar(
        title: AppStrings.Community,
        onRightIconPressed: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Community Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.community!.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.group, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Community Info and Actions
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.community!.name,
                            style:  TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.appColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => Get.to(MembersInCommunity(communityId: widget.community!.id)),
                            child: Text(
                              '${widget.community!.totalMembers} ${widget.community!.totalMembers <= 1 ? "member" : "members"}',
                              style:  TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.moreblue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Action Buttons
                          if (!widget.isAllCommunity || isJoined)
                            Wrap(
                              spacing: 8,
                              children: _buildActionButtons(isJoined),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.community!.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.Slate_gray,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Posting Cost
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        'Posting Tag Cost',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.appColor,
                        ),
                      ),
                      Text(
                        '${widget.community!.cost} points',
                        style:  TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.appColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recent Posts
              if (isJoined || !widget.isAllCommunity) ...[
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.0),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Posts',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.appColor,
                        ),

                      ),
                      HomeFilterMenues(
                        onSelected: (value) {

                            homeController.sortPosts();

                          print("selected=>$value");
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: RandomSizedPostsScreen(
                    isShowFilter: false,
                    isCommunityDetails: true,
                    communityId: widget.community!.id,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(bool isJoined) {
    final List<Widget> buttons = [];

    if (!widget.isAllCommunity) {
      buttons.addAll([
        buildActionCommunityButton(
          assetPath: AppImages.addCircle,
          onTap: () => Get.toNamed(AppRoutes.post, arguments: {"communityId": widget.community!.id}),
          tooltip: "Create Post",
        ),
        buildActionCommunityButton(
          assetPath: AppImages.invite,
          onTap: () => Get.to(InviteMember(communityId: widget.community!.id)),
          tooltip: "Invite Members",
        ),
        buildActionCommunityButton(
          assetPath: AppImages.eidt,
          onTap: () => Get.toNamed(AppRoutes.editMycommunity, arguments: {"data": widget.community!}),
          tooltip: "Edit Community",
        ),
        buildActionCommunityButton(
          assetPath: AppImages.chat,
          onTap: () => Get.to(CommunityChat(communityId: widget.community!.id)),
          tooltip: "Community Chat",
        ),
      ]);
    } else if (isJoined) {
      buttons.addAll([
        buildActionCommunityButton(
          assetPath: AppImages.addCircle,
          onTap: () => Get.toNamed(AppRoutes.post, arguments: {"communityId": widget.community!.id}),
          tooltip: "Create Post",
        ),
        buildActionCommunityButton(
          assetPath: AppImages.chat,
          onTap: () => Get.to(CommunityChat(communityId: widget.community!.id)),
          tooltip: "Community Chat",
        ),
      ]);
    }

    return buttons;
  }
}