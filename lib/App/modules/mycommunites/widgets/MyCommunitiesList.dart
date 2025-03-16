import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/controller/controller_locate.dart';
import 'package:civitante/App/modules/communityDetails/view/communityDetails.dart';
import 'package:civitante/App/modules/shimmer/my_community_model.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../AddCommunity/view/addCommunity.dart';
import '../../loading/empty_data.dart';

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
          return LottieAnimationWidget();
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.filteredCommunities.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = controller.filteredCommunities[index];
              return MyCommunitiesCard(
                isAllCommunity: false,
                imageUrl: data.image,
                groupName: data.name,
                memberCount: data.totalMembers.toString(),
                data: data,
              );
            },
          );
        }
      }),
      floatingActionButton: InkWell(
        onTap: (){
          Get.to(AddCommunityScreen());
        },
        splashColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.Slate_gray.withOpacity(0.9),
                AppColors.Slate_gray.withOpacity(1.0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.Slate_gray.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16), // Padding for image
          child: Image.asset(
            AppImages.add,
            width: 24, // Adjust size as needed
            height: 24,
            color: AppColors.white, // Tint with white for contrast
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class MyCommunitiesCard extends StatelessWidget {
  final String imageUrl;
  final String groupName;
  final String memberCount;
  final MyCommunityModel data;
  final bool isAllCommunity;

  const MyCommunitiesCard({
    Key? key,
    required this.imageUrl,
    required this.groupName,
    required this.memberCount,
    required this.data,
    this.isAllCommunity = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        MyCommunityDetail(
          isAllCommunity: isAllCommunity,
          community: data,
        ),
      ),
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Community Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.group,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Community Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      groupName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$memberCount members',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Indicator
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Mine',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}