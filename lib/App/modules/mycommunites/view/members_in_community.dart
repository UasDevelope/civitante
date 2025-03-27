import 'dart:developer';

import 'package:civitante/App/modules/loading/empty_data.dart';
import 'package:civitante/App/modules/mycommunites/controller/my_community.dart';
import 'package:civitante/App/modules/shimmer/my_community_model.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../home/widgets/home_search.dart';
import '../../previewUserProfile/view/previewprofile.dart';

class MembersInCommunity extends StatelessWidget {
  final String communityId;
  const MembersInCommunity({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyCommunityController());
    controller.fetchMemberUsers(communityId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppbar(
        title: "Members",
        onRightIconPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            HomeSerchField(
              hintText: "Search members...",
              onChanged: controller.onChangeMemberUserSearch,
            ),
            const SizedBox(height: 16),

            // Members List
            Expanded(
              child: Obx(
                () {
                  if (controller.isMemberUserLoading.value) {
                    return const MyCommunityShimmer();
                  }
                  if (controller.filteredMemberUsers.isEmpty) {
                    return const LottieAnimationWidget();
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.filteredMemberUsers.length,
                    itemBuilder: (context, index) {
                      final data = controller.filteredMemberUsers[index];

                      return InkWell(
                        onTap: () => Get.to(PreviewProfileScreen(id: data.id)),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.greyShade, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Profile Avatar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  data.profileImage,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // User Info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${data.costPoints} pts',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  controller.removeMemberFromCommunity(
                                      communityId, data.id);
                                  log("Delete icon clicked");
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.red_color.withOpacity(
                                        0.1), // Light red background
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.red_color,
                                    size: 22, // Slightly bigger for visibility
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
