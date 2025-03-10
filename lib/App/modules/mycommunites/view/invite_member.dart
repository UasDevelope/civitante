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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            spacing: Get.height * 0.02,
            children: [
              HomeSerchField(
                hintText: "Search here...", // Custom hint text
                onChanged: (value) {
                  controller.onChangeNonMemberUserSearch(value);
                },
              ),
              Obx(() => controller.selectedIndexes.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        controller.addOrRemoveFromCommunity(communityId,selectedIndex:controller.selectedIndexes);
                      },
                      icon: Icon(Icons.add))
                  : Container()),
              Obx(() {
                if (controller.isNonMemberUserLoading.value) {
                  return MyCommunityShimmer();
                } else if (controller.filteredNonMemberUsers.isEmpty) {
                  return LottieAnimationWidget();
                }

                return ListView.separated(
                  itemCount: controller.filteredNonMemberUsers.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (itemBuilder, index) {
                    final data = controller.filteredNonMemberUsers[index];
                    return Obx(() {
                      final isSelected =
                          controller.selectedIndexes.contains(data.id);
                      return GestureDetector(
                        onTap: () {
                          controller.toggleSelection(data.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.greyShade),
                            color: isSelected
                                ? AppColors.light_gray
                                : Colors.white60, // Change color if selected
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Group Image
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(data.profileImage),
                                ),
                                const SizedBox(width: 16),
                                // Group Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${data.costPoints} pts',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Icon
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: AppColors.greyShade,
                                      border: Border.all(
                                          color: AppColors.greyShade),
                                      shape: BoxShape.circle),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: Get.height * 0.02,
                    );
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
