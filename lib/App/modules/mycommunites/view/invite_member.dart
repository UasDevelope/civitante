import 'package:civitante/App/modules/loading/empty_data.dart';
import 'package:civitante/App/modules/mycommunites/controller/my_community.dart';
import 'package:civitante/App/modules/shimmer/my_community_model.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import '../../home/widgets/homeAppbar.dart';
import '../../home/widgets/home_search.dart';

import 'package:civitante/App/modules/loading/empty_data.dart';
import 'package:civitante/App/modules/mycommunites/controller/my_community.dart';
import 'package:civitante/App/modules/shimmer/my_community_model.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import '../../home/widgets/homeAppbar.dart';
import '../../home/widgets/home_search.dart';

class InviteMember extends StatelessWidget {
  final String communityId;
  const InviteMember({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyCommunityController());
    controller.fetchAllUsers(communityId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppbar(
        title: "Add Member",
        onRightIconPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            HomeSerchField(
              hintText: "Search members...",
              onChanged: controller.onChangeNonMemberUserSearch,
            ),
            const SizedBox(height: 16),

            // Add Button
            Obx(
                  () => controller.selectedIndexes.isNotEmpty
                  ? ElevatedButton.icon(
                onPressed: () => controller.addOrRemoveFromCommunity(
                  communityId,
                  selectedIndex: controller.selectedIndexes,
                ),
                icon: const Icon(Icons.person_add, size: 20),
                label: const Text("Add Selected"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Members List
            Expanded(
              child: Obx(
                    () {
                  if (controller.isNonMemberUserLoading.value) {
                    return const MyCommunityShimmer();
                  }
                  if (controller.filteredNonMemberUsers.isEmpty) {
                    return const LottieAnimationWidget();
                  }

                  return ListView.separated(
                    itemCount: controller.filteredNonMemberUsers.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = controller.filteredNonMemberUsers[index];

                      return GestureDetector(
                        onTap: () => controller.toggleSelection(data.id),
                        child: Obx((){
                          final isSelected = controller.selectedIndexes.contains(data.id);

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.light_gray : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.appColor : AppColors.greyShade,
                                width: 1.5,
                              ),
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
                                    errorBuilder: (context, error, stackTrace) => Container(
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
                                Expanded(
                                  child: Column(
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
                                ),

                                // Selection Indicator
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? AppColors.appColor : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? AppColors.appColor : AppColors.greyShade,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
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