import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/controller/controller_locate.dart';
import 'package:civitante/App/modules/communityDetails/view/communityDetails.dart';
import 'package:civitante/App/modules/loading/empty_data.dart';
import 'package:civitante/App/modules/shimmer/my_community_model.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/image.dart';
import '../../AddCommunity/view/addCommunity.dart';

class MyCommunitiesList extends StatelessWidget {
  const MyCommunitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.allCommunity;
    final myCommunity = LocateController.myCommunities;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isCommunityLoading.value) {
          return MyCommunityShimmer();
        } else if (controller.filteredCommunities.isEmpty) {
          return LottieAnimationWidget();
        }
        // else if(false){
        //   return Container();
        // }
        else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.filteredCommunities.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final group = controller.filteredCommunities[index];
              return MyCommunitiesCard(
                isAllCommunity: true,
                imageUrl: group.image,
                groupName: group.name,
                memberCount: group.totalMembers.toString(),
                data: group,
                isJoined: group.isJoined,
                onJoinTap: (){
                },
              );
            },
          );
        }
      }),
      // floatingActionButton: InkWell(
      //   onTap: (){
      //     Get.to(AddCommunityScreen());
      //   },
      //   splashColor: Colors.transparent,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           AppColors.Slate_gray.withOpacity(0.9),
      //           AppColors.Slate_gray.withOpacity(1.0),
      //         ],
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //       shape: BoxShape.circle,
      //       boxShadow: [
      //         BoxShadow(
      //           color: AppColors.Slate_gray.withOpacity(0.4),
      //           blurRadius: 12,
      //           offset: const Offset(0, 4),
      //         ),
      //       ],
      //     ),
      //     padding: const EdgeInsets.all(16), // Padding for image
      //     child: Image.asset(
      //       AppImages.add,
      //       width: 24, // Adjust size as needed
      //       height: 24,
      //       color: AppColors.white, // Tint with white for contrast
      //       fit: BoxFit.contain,
      //     ),
      //   ),
      // ),

    );
  }
}

class MyCommunitiesCard extends StatelessWidget {
  final String imageUrl;
  final String groupName;
  final String memberCount;
  final MyCommunityModel? data;
  final bool isAllCommunity;
  final bool isJoined;
  final VoidCallback? onJoinTap;

  const MyCommunitiesCard(
      {Key? key,
      required this.imageUrl,
      required this.groupName,
      required this.memberCount,
        this.isJoined=false,
        this.isAllCommunity=false,
        this.onJoinTap,
      this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(MyCommunityDetail(
          isAllCommunity: isAllCommunity,
          community: data,
        ));
      },
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
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
              if(!isJoined)
              InkWell(
                  onTap: onJoinTap,
                  child: const Icon(Icons.person, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
