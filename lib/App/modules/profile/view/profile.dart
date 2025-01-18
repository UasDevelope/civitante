import 'package:civitante/App/modules/drawer/view/drawer.dart';
import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/shared/app_button.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/widgets/engament_row.dart';
import '../widget/status_row.dart';
import '../widget/warning.dart';

class ProfileController extends GetxController {
  // Example dynamic data
  var posts = 1532.obs;
  var followers = 4310.obs;
  var following = 1310.obs;

  // List of images for the grid
  var images = [
    AppImages.arrowup,
    AppImages.arrowup,
    AppImages.arrowup,
  ].obs;
}

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: HomeAppbar(
        title: "Profile",
        rightIcon: AppImages.notification,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Warning(),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(AppImages.person),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: AppText(
                                  text: "Sara Mathew",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.appColor),
                            ),
                            Image.asset(
                              AppImages.share,
                              height: 25,
                              width: 25,
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent, // Transparent background
                            shadowColor: Colors.transparent, // Remove shadow
                            side: BorderSide(
                                color: AppColors.textFieldHintColor,
                                width: 0.4), // Black border
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            // Follow action
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppText(
                                text: '+ Follow',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.Slate_gray),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 5),
              child: Row(
                children: [
                  Image.asset(
                    AppImages.location,
                    height: 20,
                  ),
                  AppText(text: "Bangalore, India")
                ],
              ),
            ),
            // Stats Section
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Container(
                height: 60, // Define the height for the Row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatItem(title: 'Posts', value: controller.posts.value),
                    VerticalDivider(
                      color: Colors.grey, // Color of the divider
                      thickness: 1, // Thickness of the divider
                      width: 20, // Space occupied by the divider
                      indent: 10, // Top padding
                      endIndent: 10, // Bottom padding
                    ),
                    StatItem(
                        title: 'Followers', value: controller.followers.value),
                    VerticalDivider(
                      color: Colors.grey, // Color of the divider
                      thickness: 1, // Thickness of the divider
                      width: 20, // Space occupied by the divider
                      indent: 10, // Top padding
                      endIndent: 10, // Bottom padding
                    ),
                    StatItem(
                        title: 'Following', value: controller.following.value),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),
            StatsRow(),

            // Grid Section
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(
                () => GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return GridItem(imageUrl: controller.images[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final int value;

  const StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
            text: value.toString(),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.appColor),
        SizedBox(height: 4),
        AppText(
            text: title,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.Slate_gray),
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  final String imageUrl;

  const GridItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(AppImages.rectangle),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Spread items evenly
                children: [
                  // Views Row
                  buildStatItem(
                    icon: Image.asset(
                      AppImages.view, // Replace with AppImages.view
                      height: 20,
                      color: AppColors.white, // Add custom color to the icon
                    ),
                    label: '25',
                    textColor: AppColors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Likes Row
                  buildStatItem(
                    icon: Image.asset(
                      AppImages.like, // Replace with AppImages.view
                      height: 15,
                      color: AppColors.white, // Add custom color to the icon
                    ),
                    label: '25',
                    textColor: AppColors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Comments Row
                  buildStatItem(
                    icon: Image.asset(
                      AppImages.comment, // Replace with AppImages.view
                      height: 15,
                      color: AppColors.white, // Add custom color to the icon
                    ),
                    label: '25',
                    textColor: AppColors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
