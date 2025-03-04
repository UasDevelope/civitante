import 'package:civitante/App/modules/followlist/controller/followlist_controller.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/app_text.dart';
import '../../../shared/color.dart';

class FollowListScreen extends StatelessWidget {
  FollowListScreen(
      {super.key, required this.isFollowing, required this.userID,
        this.isCurrentUser = false});

  final bool isFollowing;
  final String userID;
  final bool isCurrentUser;

  final FollowListController controller = Get.put(FollowListController());

  @override
  Widget build(BuildContext context) {
    controller.getFollowers(isCurrentUser?"/getProfile/":"/getProfile/$userID");
    print("Followers heere: ${controller.user}");
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: AppText(
            text: isFollowing ? "Following" : "Followers",
            fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                future: controller.getFollowers(isCurrentUser?"/getProfile/":"/getProfile/$userID"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (controller.user.value != null) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: isFollowing
                          ? (controller.user.value?.following?.length ?? 0)
                          : (controller.user.value?.followers?.length ?? 0),
                      itemBuilder: (context, index) {
                        // Ensure we do not access out of range index
                        if ((isFollowing && (controller.user.value?.following?.isEmpty ?? true)) ||
                            (!isFollowing && (controller.user.value?.followers?.isEmpty ?? true))) {
                          return SizedBox.shrink(); // Return an empty widget if list is empty
                        }

                        var user = isFollowing
                            ? controller.user.value!.following[index]
                            : controller.user.value!.followers[index];

                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.Slate_gray,
                                spreadRadius: -1,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor:AppColors.light_gray,
                                backgroundImage: (user.profileImage == null || user.profileImage.isEmpty)
                                    ? AssetImage(AppImages.user) as ImageProvider
                                    : NetworkImage(user.profileImage),
                              ),
                              SizedBox(width: 10),
                              AppText(
                                text: user.name ?? "Unknown",
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                    );
                  } else {
                    return Center(
                      child: AppText(text: "No data fount"),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
