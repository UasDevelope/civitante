import 'package:civitante/App/controller/controller_locate.dart';
import 'package:civitante/App/modules/communityDetails/view/communityDetails.dart';
import 'package:civitante/App/modules/shimmer/my_community_model.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyCommunitiesList extends StatelessWidget {
  const MyCommunitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.myCommunities;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.communityLoading.value) {
          return MyCommunityShimmer();
        } else if (controller.filteredCommunities.isEmpty) {
          return Container();
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.filteredCommunities.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = controller.filteredCommunities[index];
              return MyCommunitiesCard(
                imageUrl: data.image,
                groupName: data.name,
                memberCount: data.totalMembers.toString(),
              );
            },
          );
        }
      }),
    );
  }
}

class MyCommunitiesCard extends StatelessWidget {
  final String imageUrl;
  final String groupName;
  final String memberCount;

  const MyCommunitiesCard({
    Key? key,
    required this.imageUrl,
    required this.groupName,
    required this.memberCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(MyCommunityDetail());
      },
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Group Image
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 16),
              // Group Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$memberCount members',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Icon
              const Icon(Icons.person, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
