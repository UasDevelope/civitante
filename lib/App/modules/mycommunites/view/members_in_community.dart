import 'package:civitante/App/modules/loading/empty_data.dart';
import 'package:civitante/App/modules/mycommunites/controller/my_community.dart';
import 'package:civitante/App/modules/shimmer/my_community_model.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import '../../home/widgets/homeAppbar.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            spacing: Get.height * 0.02,
            children: [
              HomeSerchField(
                hintText: "Search here...", // Custom hint text
                onChanged: (value) {
                  controller.onChangeMemberUserSearch(value);
                },
              ),
              Obx(() {
                if (controller.isMemberUserLoading.value) {
                  return MyCommunityShimmer();
                } else if (controller.filteredMemberUsers.isEmpty) {
                  return LottieAnimationWidget();
                }

                return ListView.separated(
                  itemCount: controller.filteredMemberUsers.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (itemBuilder, index) {
                    final data = controller.filteredMemberUsers[index];
                    return InkWell(
                     onTap: (){
                       Get.to(PreviewProfileScreen(id: data.id,));
                     },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.greyShade),
                          color: Colors.white60,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Profile Image
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(data.profileImage),
                              ),
                              const SizedBox(width: 16),
                              // User Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              // Chat Icon inside a Circle
                            ],
                          ),
                        ),
                      ),
                    );
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
